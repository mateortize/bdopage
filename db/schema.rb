# encoding: UTF-8
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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20140624145921) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_profiles", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "account_profiles", ["account_id"], name: "index_account_profiles_on_account_id", using: :btree

  create_table "account_settings", force: true do |t|
    t.string   "blog_alias"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "account_settings", ["account_id"], name: "index_account_settings_on_account_id", using: :btree

  create_table "accounts", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "videos_count",           default: 0
    t.integer  "posts_count",            default: 0
  end

  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "comments", force: true do |t|
    t.integer  "parent_id"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "post_id"
    t.integer  "account_id"
  end

  add_index "comments", ["account_id"], name: "index_comments_on_account_id", using: :btree
  add_index "comments", ["post_id"], name: "index_comments_on_post_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.text     "excerpt"
    t.integer  "video_id"
  end

  add_index "posts", ["account_id"], name: "index_posts_on_account_id", using: :btree

  create_table "videos", force: true do |t|
    t.string   "title"
    t.string   "panda_video_id"
    t.string   "screenshot"
    t.string   "h264_url"
    t.string   "ogg_url"
    t.string   "height"
    t.string   "width"
    t.string   "file_size"
    t.string   "profile"
    t.boolean  "encoded",        default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "url"
  end

  add_index "videos", ["account_id"], name: "index_videos_on_account_id", using: :btree

end
