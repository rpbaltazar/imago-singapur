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

ActiveRecord::Schema.define(version: 20140929123649) do

  create_table "people", force: true do |t|
    t.string   "nickname"
    t.datetime "arrival_date"
    t.string   "sex"
    t.datetime "exit_date"
    t.datetime "birthday"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",     limit: 128, default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
  end

  create_table "tags", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "testimonies", force: true do |t|
    t.float    "lat"
    t.float    "lon"
    t.datetime "story_date"
    t.string   "memory"
    t.string   "audio_url"
    t.string   "video_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.string   "image_url"
    t.string   "memory_img_file_name"
    t.string   "memory_img_content_type"
    t.integer  "memory_img_file_size"
    t.datetime "memory_img_updated_at"
  end

  add_index "testimonies", ["person_id"], name: "index_testimonies_on_person_id"

end
