class Hashtag < ActiveRecord::Base

has_many :links, :foreign_key => "hashtag_id",
                           :dependent => :destroy
has_many :tweets, :through => :links, :source => :tweet

end
