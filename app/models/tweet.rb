class Tweet < ActiveRecord::Base

has_many :links, :foreign_key => "tweet_id",
                           :dependent => :destroy
has_many :hashtags, :through => :links, :source => :hashtag

validates :t_id, :presence => true,
                 :uniqueness => true

validates :text, :presence => true

validates :user, :presence => true

validates :timestamp, :presence => true 


end
