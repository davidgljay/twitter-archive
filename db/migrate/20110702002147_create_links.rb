class CreateLinks < ActiveRecord::Migration
  def self.up
    create_table :links do |t|
      t.integer :tweet_id
      t.integer :hashtag_id

      t.timestamps
    end
    add_index :links, :tweet_id
    add_index :links, :hashtag_id
    add_index :links, [:tweet_id, :hashtag_id], :unique => true
  end

  def self.down
    drop_table :links
  end
end
