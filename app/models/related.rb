class Related < ActiveRecord::Base

belongs_to :hashtag, :class_name => "Hashtag"
belongs_to :related, :class_name => "Hashtag"

end

