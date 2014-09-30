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

ActiveRecord::Schema.define(version: 20140930120202) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_profiles", force: true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "avatar"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.text     "description"
    t.string   "private_fields"
  end

  add_index "account_profiles", ["account_id"], name: "index_account_profiles_on_account_id", using: :btree

  create_table "account_settings", force: true do |t|
    t.string   "blog_alias"
    t.boolean  "blog_enabled"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.string   "blog_logo"
    t.datetime "blog_alias_changed_at"
  end

  add_index "account_settings", ["account_id"], name: "index_account_settings_on_account_id", using: :btree

  create_table "accounts", force: true do |t|
    t.string   "email",                     default: "", null: false
    t.string   "encrypted_password",        default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",             default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "videos_count",              default: 0
    t.integer  "posts_count",               default: 0
    t.string   "promotion_code"
    t.integer  "bonofa_partner_account_id"
  end

  add_index "accounts", ["bonofa_partner_account_id"], name: "index_accounts_on_bonofa_partner_account_id", using: :btree
  add_index "accounts", ["email"], name: "index_accounts_on_email", unique: true, using: :btree
  add_index "accounts", ["promotion_code"], name: "index_accounts_on_promotion_code", using: :btree
  add_index "accounts", ["reset_password_token"], name: "index_accounts_on_reset_password_token", unique: true, using: :btree

  create_table "addresses", force: true do |t|
    t.integer  "addressable_id"
    t.string   "addressable_type"
    t.string   "address_1"
    t.string   "address_2"
    t.string   "city"
    t.string   "state"
    t.string   "postal_code"
    t.string   "country_code"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "addresses", ["addressable_id", "addressable_type"], name: "index_addresses_on_addressable_id_and_addressable_type", using: :btree

  create_table "authentications", force: true do |t|
    t.integer  "account_id"
    t.string   "provider"
    t.integer  "uid"
    t.string   "token"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authentications", ["account_id"], name: "index_authentications_on_account_id", using: :btree

  create_table "bootsy_image_galleries", force: true do |t|
    t.integer  "bootsy_resource_id"
    t.string   "bootsy_resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bootsy_images", force: true do |t|
    t.string   "image_file"
    t.integer  "image_gallery_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string "name"
    t.string "description"
  end

  create_table "commontator_comments", force: true do |t|
    t.string   "creator_type"
    t.integer  "creator_id"
    t.string   "editor_type"
    t.integer  "editor_id"
    t.integer  "thread_id",                     null: false
    t.text     "body",                          null: false
    t.datetime "deleted_at"
    t.integer  "cached_votes_up",   default: 0
    t.integer  "cached_votes_down", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_comments", ["cached_votes_down"], name: "index_commontator_comments_on_cached_votes_down", using: :btree
  add_index "commontator_comments", ["cached_votes_up"], name: "index_commontator_comments_on_cached_votes_up", using: :btree
  add_index "commontator_comments", ["creator_id", "creator_type", "thread_id"], name: "index_commontator_comments_on_c_id_and_c_type_and_t_id", using: :btree
  add_index "commontator_comments", ["thread_id"], name: "index_commontator_comments_on_thread_id", using: :btree

  create_table "commontator_subscriptions", force: true do |t|
    t.string   "subscriber_type", null: false
    t.integer  "subscriber_id",   null: false
    t.integer  "thread_id",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_subscriptions", ["subscriber_id", "subscriber_type", "thread_id"], name: "index_commontator_subscriptions_on_s_id_and_s_type_and_t_id", unique: true, using: :btree
  add_index "commontator_subscriptions", ["thread_id"], name: "index_commontator_subscriptions_on_thread_id", using: :btree

  create_table "commontator_threads", force: true do |t|
    t.string   "commontable_type"
    t.integer  "commontable_id"
    t.datetime "closed_at"
    t.string   "closer_type"
    t.integer  "closer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "commontator_threads", ["commontable_id", "commontable_type"], name: "index_commontator_threads_on_c_id_and_c_type", unique: true, using: :btree

  create_table "follows", force: true do |t|
    t.integer  "followable_id",                   null: false
    t.string   "followable_type",                 null: false
    t.integer  "follower_id",                     null: false
    t.string   "follower_type",                   null: false
    t.boolean  "blocked",         default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["followable_id", "followable_type"], name: "fk_followables", using: :btree
  add_index "follows", ["follower_id", "follower_type"], name: "fk_follows", using: :btree

  create_table "orders", force: true do |t|
    t.integer  "account_id"
    t.string   "plan_type"
    t.integer  "status",         default: 0
    t.integer  "tax_cents"
    t.integer  "total_cents"
    t.integer  "subtotal_cents"
    t.string   "payment_method"
    t.string   "transaction_id"
    t.string   "invoice_file"
    t.string   "card_brand"
    t.string   "last_4_digits"
    t.text     "info"
    t.date     "expired_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "token"
  end

  add_index "orders", ["account_id"], name: "index_orders_on_account_id", using: :btree
  add_index "orders", ["expired_at"], name: "index_orders_on_expired_at", using: :btree
  add_index "orders", ["plan_type"], name: "index_orders_on_plan_type", using: :btree
  add_index "orders", ["status"], name: "index_orders_on_status", using: :btree
  add_index "orders", ["transaction_id"], name: "index_orders_on_transaction_id", using: :btree

  create_table "pages", force: true do |t|
    t.string   "slug"
    t.string   "title"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
  end

  add_index "pages", ["account_id"], name: "index_pages_on_account_id", using: :btree

  create_table "posts", force: true do |t|
    t.string   "title"
    t.text     "content"
    t.text     "excerpt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "account_id"
    t.integer  "video_id"
    t.string   "video_url"
    t.boolean  "published"
    t.string   "status"
    t.datetime "deleted_at"
    t.integer  "category_id"
    t.integer  "views_count", default: 0
  end

  add_index "posts", ["account_id"], name: "index_posts_on_account_id", using: :btree
  add_index "posts", ["deleted_at"], name: "index_posts_on_deleted_at", using: :btree
  add_index "posts", ["views_count"], name: "index_posts_on_views_count", using: :btree

  create_table "video_encodings", force: true do |t|
    t.string   "profile_name"
    t.string   "status"
    t.string   "url"
    t.integer  "file_size"
    t.integer  "width"
    t.integer  "height"
    t.integer  "video_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "video_encodings", ["video_id"], name: "index_video_encodings_on_video_id", using: :btree

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
    t.integer  "post_id"
  end

  add_index "videos", ["account_id"], name: "index_videos_on_account_id", using: :btree

end
