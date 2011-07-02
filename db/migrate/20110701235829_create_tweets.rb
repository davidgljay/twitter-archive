class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer :t_id
      t.string :text
      t.string :user
      t.timestamp :timestamp

      t.timestamps
    end
     add_index :tweets, :t_id
  end

  def self.down
    drop_table :tweets
  end
end
