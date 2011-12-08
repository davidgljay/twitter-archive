class AddPhraseToHashtags < ActiveRecord::Migration
  def self.up
    add_column :hashtags, :phrase, :boolean
  end

  def self.down
    remove_column :hashtags, :phrase
  end
end
