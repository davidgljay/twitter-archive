class Tweet < ActiveRecord::Base

has_many :links, :foreign_key => "tweet_id",
                           :dependent => :destroy
has_many :hashtags, :through => :links, :source => :hashtag

validates :t_id, :presence => true,
                 :uniqueness => true

validates :text, :presence => true

validates :user, :presence => true

validates :timestamp, :presence => true 

## before_save :derive_hashtags

 def derive_hashtags
   self.text.split(/[.,!"?'&\s]/).each do |word|
   #If the word starts with '#'
      word.downcase!
      reg = /#/
      if word.match(reg) != nil
         hash = Hashtag.find_or_create_by_name(word)
         if hash.numtweets.nil? || hash.numtweets == 0
            hash.numtweets = 1
            hash.save
         end
         self.hashtags << hash unless self.hashtags.include?(hash)
      end
    end
    Hashtag.where(:phrase => true).each do |phrase|
      if self.text.include?(phrase.name)
        self.hashtags << phrase unless self.hashtags.include?(phrase)
      end
    end
    self.hashtags
  end

  def get_hashtags
    hashes = []
    self.text.split(/[.,!"?'&\s]/).each do |word|
      word.downcase!
      reg = /#/
      if word.match(reg) != nil
         hash = Hashtag.find_or_create_by_name(word)
         if hash.numtweets.nil?
            hash.numtweets = 1
            hash.save
         end
         hashes << hash
      end
     end
     hashes
  end
end
