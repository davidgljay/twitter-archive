require 'twitter'

class Hashtag < ActiveRecord::Base

has_many :links, :foreign_key => "hashtag_id",
                           :dependent => :destroy
has_many :tweets, :through => :links, :source => :tweet


validates :name, :presence => true,
                      :uniqueness => true

def get_tweets 
   Twitter::Search.new.containing(self.name).each do |tweet|
     Tweet.create(:t_id => tweet.id, :text => tweet.text, :user => tweet.from_user, :timestamp => tweet.created_at.to_time)
   end
end 
   

end
