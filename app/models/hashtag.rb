require 'twitter'

class Hashtag < ActiveRecord::Base

#before_save :default_values

has_many :links, :foreign_key => "hashtag_id",
                           :dependent => :destroy
has_many :tweets, :through => :links, :source => :tweet


validates :name, :presence => true,
                      :uniqueness => true

  def get_tweets 
   Twitter::Search.new.containing(self.name).each do |tweet|
     Tweet.create(:t_id => tweet.id, :text => tweet.text, :user => tweet.from_user, :timestamp => tweet.created_at.to_time).derive_hashtags if Tweet.find_by_t_id(tweet.id).nil?
     self.numtweets = self.tweets.count
     self.save
   end

   def get_related_hashtags
     self.tweets.each.do |tweet|
       tweet.hashtags.each.do |hashtag|
         hashtag.name unless list.include?(hashtag.name)
       end
     end
   end
