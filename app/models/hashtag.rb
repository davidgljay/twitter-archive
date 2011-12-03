require 'twitter'

class Hashtag < ActiveRecord::Base

#before_save :default_values

has_many :links, :foreign_key => "hashtag_id",
                           :dependent => :destroy
has_many :tweets, :through => :links, :source => :tweet


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
     end
   end
   self.update_numtweets
  end



  def sync
    @synclist = Hashtag.all.delete_if{|tag| tag.archive == false}
    secondaries = Array.new
    @synclist.each do |tag|
       tag.tweets.each do |tweet|
         secondaries << tweet.hashtags
       end
    end
    @synclist << secondaries
    @synclist.flatten!.uniq!.each do |tag|
       tag.delay.get_tweets
    end
  end

  def update_numtweets
     self.numtweets = self.tweets.all.delete_if{|t| t.created_at < Time.now - 1.month}.count
     self.save
  end

  def update_all_numtweets
    Hashtag.all.each do |h|
     h.numtweets = h.tweets.all.delete_if{|t| t.created_at < Time.now - 1.month}.count
     h.save
    end
   end


# Create an array of related hashtags.
   def get_related_hashtags
     map_a = self.tweets.map{|tweet| tweet.hashtags.map{|hash| hash}}
     map_a.flatten!.delete_if{|tag| tag == self} unless map_a.count == 0
     hash_matrix = Array.new
     map_a.uniq.each do |tag|
     if tag.numtweets > numtweets
        intersect = (map_a.count(tag)*100)/numtweets
     else
        intersect = (map_a.count(tag)*100)/tag.numtweets
     end
         hash_matrix << [tag.name, map_a.count(tag), tag.numtweets, tag, intersect]
     end
     hash_matrix.sort_by{|hash| hash[4]}.reverse.delete_if{|hash| hash[2] < 50}
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
      get_related_hashtags.delete_if{|hash| hash[2] < numtweets}
   end

   def smaller_hashes
      get_related_hashtags.delete_if{|hash| hash[2] > numtweets}
   end

private

def fix_numtweets
   if numtweets.nil?
     numtweets = 1
   end
end

end
