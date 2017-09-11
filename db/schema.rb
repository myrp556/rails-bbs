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

ActiveRecord::Schema.define(version: 20170911075639) do

  create_table "agents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "zone_id"
  end

  add_index "agents", ["user_id"], name: "index_agents_on_user_id"
  add_index "agents", ["zone_id"], name: "index_agents_on_zone_id"

  create_table "balls", force: :cascade do |t|
    t.integer  "zone_id"
    t.datetime "expire"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "balls", ["user_id"], name: "index_balls_on_user_id"

  create_table "ckeditor_assets", force: :cascade do |t|
    t.string   "data_file_name",               null: false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.string   "type",              limit: 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "ckeditor_assets", ["type"], name: "index_ckeditor_assets_on_type"

  create_table "favorites", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "favorites", ["user_id"], name: "index_favorites_on_user_id"

  create_table "hexes", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text     "note_detail"
    t.integer  "floor",            default: 0
    t.integer  "zone_id",          default: 0
    t.integer  "topic_id"
    t.integer  "user_id"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.integer  "reply_to"
    t.integer  "parse_to"
    t.integer  "reply_to_user_id"
    t.boolean  "rate",             default: false
    t.integer  "rated",            default: 0
  end

  add_index "notes", ["created_at"], name: "index_notes_on_created_at"
  add_index "notes", ["topic_id"], name: "index_notes_on_topic_id"
  add_index "notes", ["user_id"], name: "index_notes_on_user_id"

  create_table "pmails", force: :cascade do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.text     "mail_detail"
    t.text     "sender_name"
    t.text     "receiver_name"
    t.boolean  "readed",        default: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
  end

  create_table "topics", force: :cascade do |t|
    t.string   "topic_detail"
    t.string   "note_detail"
    t.boolean  "is_top",        default: false
    t.integer  "zone_id"
    t.integer  "user_id"
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.integer  "floor_count",   default: 0
    t.integer  "first_user_id"
    t.integer  "last_user_id"
    t.string   "color"
    t.boolean  "nice"
    t.integer  "hot",           default: 0
  end

  add_index "topics", ["updated_at"], name: "index_topics_on_updated_at"
  add_index "topics", ["user_id"], name: "index_topics_on_user_id"
  add_index "topics", ["zone_id"], name: "index_topics_on_zone_id"

  create_table "users", force: :cascade do |t|
    t.string   "user_name"
    t.string   "name"
    t.string   "mail"
    t.string   "number"
    t.integer  "rank",            default: 0
    t.integer  "zone_auth"
    t.string   "icon"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "topic_id"
    t.integer  "note_id"
    t.integer  "rate_point",      default: 3
    t.integer  "point",           default: 0
  end

  add_index "users", ["note_id"], name: "index_users_on_note_id"
  add_index "users", ["topic_id"], name: "index_users_on_topic_id"

  create_table "vote_options", force: :cascade do |t|
    t.integer  "vote_id"
    t.integer  "count"
    t.string   "description"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "vote_options", ["vote_id"], name: "index_vote_options_on_vote_id"

  create_table "vote_user_agents", force: :cascade do |t|
    t.integer  "vote_id"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "vote_user_agents", ["user_id"], name: "index_vote_user_agents_on_user_id"
  add_index "vote_user_agents", ["vote_id"], name: "index_vote_user_agents_on_vote_id"

  create_table "votes", force: :cascade do |t|
    t.integer  "topic_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "expire"
  end

  add_index "votes", ["topic_id"], name: "index_votes_on_topic_id"

  create_table "yys", force: :cascade do |t|
    t.string   "number"
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "zones", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "icon"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.integer  "today_notes", default: 0
    t.text     "bulletin"
    t.boolean  "anonymous",   default: false
    t.integer  "rank",        default: 0
  end

end
