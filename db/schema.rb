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

ActiveRecord::Schema.define(version: 20150721114242) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "contacts", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stored_phone_number"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "request_counters", force: :cascade do |t|
    t.integer "counter", default: 0
  end

  create_table "users", force: :cascade do |t|
    t.string   "token"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "stored_phone_number"
    t.string   "image_url"
    t.float    "lat",                   default: 0.0
    t.float    "lon",                   default: 0.0
    t.string   "nearby_friends_infos",  default: ""
    t.string   "nearby_friends_tokens", default: ""
    t.string   "password_digest"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
