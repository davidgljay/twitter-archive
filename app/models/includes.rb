class Includes < ActiveRecord::Base

belongs_to :tweet, :class_name => "Tweet"
belongs_to :hashtag, :class_name => "Hashtag"

end
