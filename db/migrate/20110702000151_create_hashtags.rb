class CreateHashtags < ActiveRecord::Migration
  def self.up
    create_table :hashtags do |t|
      t.string :name
      t.integer :numtweets
      t.boolean :archive, :default => false

      t.timestamps
    end
     add_index :hashtags, :name
  end

  def self.down
    drop_table :hashtags
  end
end
