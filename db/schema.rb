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

ActiveRecord::Schema.define(version: 20150406101358) do

  create_table "authentications", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "books", force: :cascade do |t|
    t.boolean  "building"
    t.string   "title"
    t.string   "cover_url"
    t.integer  "user_id",      null: false
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "gitlab_id"
    t.string   "slug"
    t.string   "version"
    t.datetime "version_time"
  end

  add_index "books", ["user_id"], name: "index_books_on_user_id"

  create_table "entries", force: :cascade do |t|
    t.string  "path",    null: false
    t.integer "book_id", null: false
  end

  add_index "entries", ["book_id", "path"], name: "index_entries_on_book_id_and_path", unique: true
  add_index "entries", ["book_id"], name: "index_entries_on_book_id"

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 64, null: false
    t.string   "avatar_url"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "email"
    t.integer  "gitlab_id"
    t.string   "gitlab_password"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
