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

ActiveRecord::Schema.define(version: 20150909071020) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.integer  "author_id"
    t.string   "author_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"

  create_table "authentications", force: :cascade do |t|
    t.string   "uid"
    t.string   "provider"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "authors", force: :cascade do |t|
    t.string   "pen_name"
    t.string   "gitlab_username"
    t.string   "gitlab_password"
    t.integer  "user_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.text     "intro"
    t.text     "slogan"
    t.string   "avatar"
    t.string   "gitlab_id"
  end

  create_table "books", force: :cascade do |t|
    t.boolean  "building"
    t.string   "title"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "gitlab_id"
    t.string   "slug"
    t.string   "version"
    t.datetime "version_time"
    t.text     "readme"
    t.text     "summary"
    t.string   "cover"
    t.boolean  "explored"
    t.integer  "author_id"
    t.text     "intro"
    t.string   "profit"
    t.decimal  "price"
    t.boolean  "donate"
    t.datetime "deleted_at"
  end

  add_index "books", ["deleted_at"], name: "index_books_on_deleted_at"

  create_table "builds", force: :cascade do |t|
    t.integer  "book_id"
    t.string   "commit"
    t.string   "tag"
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string   "aasm_state"
    t.boolean  "published"
  end

  create_table "entries", force: :cascade do |t|
    t.string  "path",    null: false
    t.integer "book_id", null: false
  end

  add_index "entries", ["book_id", "path"], name: "index_entries_on_book_id_and_path", unique: true
  add_index "entries", ["book_id"], name: "index_entries_on_book_id"

  create_table "orders", id: false, force: :cascade do |t|
    t.string   "id",           null: false
    t.integer  "book_id"
    t.integer  "purchaser_id"
    t.string   "aasm_state"
    t.decimal  "fee"
    t.string   "wx_prepay_id"
    t.string   "wx_code_url"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "author_id"
    t.string   "profit"
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",   limit: 64, null: false
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.string   "email"
    t.string   "avatar"
    t.boolean  "is_confirm"
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true

  create_table "wechat_authentications", force: :cascade do |t|
    t.string   "access_token"
    t.string   "refresh_token"
    t.string   "openid"
    t.string   "unionid"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
