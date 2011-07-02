class Tweet < ActiveRecord::Base

has_many :links, :foreign_key => "tweet_id",
                           :dependent => :destroy
has_many :hashtags, :through => :links, :source => :hashtag

end
