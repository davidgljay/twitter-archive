# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110702002147) do

  create_table "hashtags", :force => true do |t|
    t.string   "name"
    t.integer  "numtweets"
    t.boolean  "archive",    :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hashtags", ["name"], :name => "index_hashtags_on_name"

  create_table "links", :force => true do |t|
    t.integer  "tweet_id"
    t.integer  "hashtag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "links", ["hashtag_id"], :name => "index_links_on_hashtag_id"
  add_index "links", ["tweet_id", "hashtag_id"], :name => "index_links_on_tweet_id_and_hashtag_id", :unique => true
  add_index "links", ["tweet_id"], :name => "index_links_on_tweet_id"

  create_table "tweets", :force => true do |t|
    t.string   "t_id"
    t.string   "text"
    t.string   "user"
    t.datetime "timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["t_id"], :name => "index_tweets_on_t_id"

end
