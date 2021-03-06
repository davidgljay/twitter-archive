class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :t_id
      t.string :text
      t.string :user
      t.string :timestamp

      t.timestamps
    end
     add_index :tweets, :t_id
  end

  def self.down
    drop_table :tweets
  end
end
