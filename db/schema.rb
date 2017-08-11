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

ActiveRecord::Schema.define(version: 20170811025251) do

  create_table "agents", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "zone_id"
  end

  add_index "agents", ["user_id"], name: "index_agents_on_user_id"
  add_index "agents", ["zone_id"], name: "index_agents_on_zone_id"

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

  create_table "hexes", force: :cascade do |t|
    t.string   "url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes", force: :cascade do |t|
    t.text     "note_detail"
    t.integer  "floor",       default: 0
    t.integer  "topic_id"
    t.integer  "user_id"
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "notes", ["created_at"], name: "index_notes_on_created_at"
  add_index "notes", ["topic_id"], name: "index_notes_on_topic_id"
  add_index "notes", ["user_id"], name: "index_notes_on_user_id"

  create_table "topics", force: :cascade do |t|
    t.string   "topic_detail"
    t.string   "note_detail"
    t.integer  "zone_id"
    t.integer  "user_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "floor_count",  default: 0
  end

  add_index "topics", ["updated_at"], name: "index_topics_on_updated_at"
  add_index "topics", ["user_id"], name: "index_topics_on_user_id"
  add_index "topics", ["zone_id"], name: "index_topics_on_zone_id"

  create_table "users", force: :cascade do |t|
    t.string   "user_name"
    t.string   "name"
    t.string   "mail"
    t.string   "number"
    t.integer  "rank"
    t.integer  "zone_auth"
    t.string   "icon"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.integer  "topic_id"
    t.integer  "note_id"
  end

  add_index "users", ["note_id"], name: "index_users_on_note_id"
  add_index "users", ["topic_id"], name: "index_users_on_topic_id"

  create_table "zones", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.string   "icon"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

end
