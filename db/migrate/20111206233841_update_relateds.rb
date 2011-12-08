class UpdateRelateds < ActiveRecord::Migration
  def self.up
    add_index :relateds, :hashtag_id
    remove_column :relateds, :intersection
    add_column :relateds, :intersection, :integer
  end

  def self.down
  end
end
