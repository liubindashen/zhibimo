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

ActiveRecord::Schema.define(version: 20150617041306) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "authentications", force: :cascade do |t|
    t.string   "uid",        limit: 255
    t.string   "provider",   limit: 255
    t.integer  "user_id",    limit: 4
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "books", force: :cascade do |t|
    t.boolean  "building",     limit: 1
    t.string   "title",        limit: 255
    t.string   "cover_url",    limit: 255
    t.integer  "user_id",      limit: 4,     null: false
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.integer  "gitlab_id",    limit: 4
    t.string   "slug",         limit: 255
    t.string   "version",      limit: 255
    t.datetime "version_time"
    t.text     "readme",       limit: 65535
    t.text     "summary",      limit: 65535
    t.string   "cover",        limit: 255
    t.boolean  "explored",     limit: 1
  end

  add_index "books", ["user_id"], name: "index_books_on_user_id", using: :btree

  create_table "entries", force: :cascade do |t|
    t.string  "path",    limit: 255, null: false
    t.integer "book_id", limit: 4,   null: false
  end

  add_index "entries", ["book_id", "path"], name: "index_entries_on_book_id_and_path", unique: true, using: :btree
  add_index "entries", ["book_id"], name: "index_entries_on_book_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 64,  null: false
    t.string   "avatar_url",      limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.string   "email",           limit: 255
    t.integer  "gitlab_id",       limit: 4
    t.string   "gitlab_password", limit: 255
  end

  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

  create_table "wechat_authentications", force: :cascade do |t|
    t.string   "access_token",  limit: 255
    t.string   "refresh_token", limit: 255
    t.string   "openid",        limit: 255
    t.string   "unionid",       limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
  end

end
