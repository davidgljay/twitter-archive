class Link < ActiveRecord::Base

belongs_to :hashtag, :class_name => "Hashtag"
belongs_to :tweet, :class_name => "Tweet"

end
