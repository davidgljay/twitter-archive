require 'twitter'

class Hashtag < ActiveRecord::Base

#before_save :default_values

has_many :links, :foreign_key => "hashtag_id",
                           :dependent => :destroy
has_many :tweets, :through => :links, :source => :tweet

has_many :relateds, :foreign_key => "hashtag_id",
                            :dependent => :destroy

has_many :related_hashtags, :through=> :relateds, 
                            :source => :related

has_many :reverse_relateds, :foreign_key =>"related_id",
                            :dependent => :destroy

validates :name, :presence => true,
                      :uniqueness => true

default_scope :order => 'hashtags.numtweets DESC'

before_save :fix_numtweets

  def search_tweets
     Twitter::Search.new.containing(self.name).per_page(100)
  end
#Get tweets for a given hashtag.
  def get_tweets 
   search_tweets.each do |tweet|
     #Can I add location data here?
     if Tweet.find_by_t_id(tweet.id.to_s).nil?
       t = Tweet.new(:t_id => tweet.id.to_s, :text => tweet.text, :user => tweet.from_user, :timestamp => tweet.created_at)
       t.save
       note_relateds(t.derive_hashtags)
     end
   end
   self.update_numtweets
  end

  # Take a list of related hashtags and note them in the database
  def note_relateds(hashes)
    hashes.each do |hash|
      if !related_hashtags.include?(hash) && self != hash
        r = relateds.create(:related_id => hash.id, :intersection => 1)
      elsif related_hashtags.include?(hash) && self != hash
        r = relateds.where(:related_id => hash.id).first
        r.intersection += 1
        r.save
      end
     end
   end

  def update_numtweets
     self.numtweets = self.tweets.all.delete_if{|t| t.created_at < Time.now - 1.month}.count
     self.save
  end


##Global functions, keeping them in Hashtag

  def sync
    @synclist = Hashtag.where(:archive => true)
    secondaries = Array.new
    @synclist.each do |tag|
      secondaries << tag.get_related_hashtags.first(100).map{|h| h[3]}
    end
    @synclist << secondaries
    @synclist.flatten.uniq.each do |tag|
       tag.delay.get_tweets
    end
    delay.update_all_numtweets
    (@synclist.flatten.uniq.count + 1).to_s + " jobs queued, taking approx " + (@synclist.flatten.uniq.count * 5/60).to_s + " minutes."
  end


  def update_all_numtweets
    Hashtag.all.each do |h|
     h.numtweets = h.tweets.all.delete_if{|t| t.created_at < Time.now - 1.month}.count
     h.save
     if h.numtweets == 0
        h.destroy
     end
    end
   end


# Create an array of related hashtags.
# 0 = Name
# 1 = Intersection
# 2 = Numtweets
# 3 = Hashtag Object
# 4 = Ratio of intersection to my numtweets
   def get_related_hashtags
     hash_matrix = []
     relateds.each do |r|
      #if r.related.numtweets > numtweets
        intersect = numtweets == 0 ? 0 : (r.intersection*100)/numtweets
      #else
      #  intersect = r.related.numtweets == 0 ? 0 :(r.intersection*100)/r.related.numtweets
      #end
      hash_matrix << [r.related.name, r.intersection, r.related.numtweets, r.related, intersect]
     end
     hash_matrix.sort_by{|hash| hash[4]}.reverse
   end     

#Trim this for the wordcloud. I'm keeping this seperate in case we want the full array at some point.
   def related_hashtag_cloud
     cloud = get_related_hashtags
     #Get rid of the ones that only intersect once.
     cloud.delete_if{|tag| tag[1] == 1}
     cloud = cloud.reverse.drop(cloud.count - 30).reverse if cloud.count > 30
     cloud
   end

   def bigger_hashes
      get_related_hashtags.delete_if{|hash| hash[2] < numtweets || hash[2] < 10}
   end

   def smaller_hashes
      get_related_hashtags.delete_if{|hash| hash[2] > numtweets || hash[2] < 10}
   end

#Create a graph with google, see http://code.google.com/apis/chart/image/docs/chart_playground.html if you have trouble
def related_graph
  charturl = 'http://chart.googleapis.com/chart?cht=s&chs=600x400&&chxt=x,x,y,y&chxl=3:|Tweets/Month|1:|% Overlap&chxp=1,50|3,50&chxs=0N**%'
  points = self.get_related_hashtags.first(25)
  x_max = points.map{|p| p[1]}.max
  y_max = points.map{|p| p[2]}.push(numtweets).max
  range = '&chds=0,' + Math.log(x_max).to_s + ',0,' + Math.log(y_max).to_s + '&chxr=0,0,' + (x_max*100/numtweets).to_s + '|2,0,' + y_max.to_s
  my_x = '100,'
  my_y = (numtweets*100/y_max).to_s + ','
 # x_vals = points.map{|p| p[1]*100/x_max} * ','
 # y_vals = points.map{|p| p[2]*100/y_max} * ','
  x_vals = points.map{|p| Math.log(p[1])} * ','
  y_vals = points.map{|p| Math.log(p[2])} * ','

  labels = '&chm=tBlank,000000,0,1,1|' #t' + name.delete('#') + '-->,087217,1,0,18|'
  25.times do |i|
    labels << 't'+ points[i][0].delete("#") + ',000000,1,' + (i+1).to_s + ',11|'
  end
  labels.chomp!('|')
  charturl << range
  charturl << '&chd=t:' + x_vals + '|'
  charturl <<  y_vals
  charturl << labels
end

private

def fix_numtweets
   if numtweets.nil?
     numtweets = 1
   end
end

end
