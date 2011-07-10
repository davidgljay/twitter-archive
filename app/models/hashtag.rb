require 'twitter'

class Hashtag < ActiveRecord::Base

#before_save :default_values

has_many :links, :foreign_key => "hashtag_id",
                           :dependent => :destroy
has_many :tweets, :through => :links, :source => :tweet


validates :name, :presence => true,
                      :uniqueness => true

default_scope :order => 'hashtags.numtweets DESC'

#Get tweets for a given hashtag.
  def get_tweets 
   Twitter::Search.new.containing(self.name).each do |tweet|
     #Can I add location data here?
     Tweet.create(:t_id => tweet.id, :text => tweet.text, :user => tweet.from_user, :timestamp => tweet.created_at.to_time).derive_hashtags if Tweet.find_by_t_id(tweet.id).nil?
     self.numtweets = self.tweets.count
     self.save
   end
  end

# Create an array of related hashtags.
   def get_related_hashtags
     map_a = self.tweets.map{|tweet| tweet.hashtags.map{|hash| hash.name}}
     map_a.flatten!.delete_if{|tag| tag == self.name}
     hash_matrix = Array.new
     map_a.uniq.each do |tag|
         hash_matrix << [tag, map_a.count(tag)]
     end
     hash_matrix
   end     

#Start archiving a hashtag. Later on I'll create an unarchive feature for admins.
#   def archive
#     self.archive = true
#     self.save
#   end

end
