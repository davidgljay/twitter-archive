class Related < ActiveRecord::Migration
  def self.up
     create_table :relateds do |t|
      t.integer :hashtag_id
      t.integer :related_id
      t.boolean :intersection
     end
  end

  def self.down
    drop_table :relateds
  end
end
