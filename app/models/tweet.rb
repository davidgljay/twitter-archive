class Tweet < ActiveRecord::Base

has_many :links, :foreign_key => "tweet_id",
                           :dependent => :destroy
has_many :hashtags, :through => :links, :source => :hashtag

validates :t_id, :presence => true,
                 :uniqueness => true

validates :text, :presence => true

validates :user, :presence => true

validates :timestamp, :presence => true 


 def derive_hashtags
   self.text.split(' ').each do |word|
   #If the word starts with '#'
      word.downcase!
      if word[0] == 35
      #Create a hashtag, and at the same time test to see if it already exists
         if self.hashtags.create(:name => word, :numtweets => 1).id.nil? 
           unless self.hashtags.find_by_name(word)
             self.links.create(:hashtag_id => Hashtag.find_by_name(word).id)
           end
         end
      end
    end
  end
end
