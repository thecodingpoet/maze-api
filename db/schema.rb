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

ActiveRecord::Schema.define(version: 20190418144726) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "comments", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "writing_id"
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "approved"
    t.index ["user_id"], name: "index_comments_on_user_id"
    t.index ["writing_id"], name: "index_comments_on_writing_id"
  end

  create_table "concerns", force: :cascade do |t|
    t.string "name"
    t.boolean "selected", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_concerns_on_user_id"
  end

  create_table "strengths", force: :cascade do |t|
    t.string "name"
    t.boolean "selected", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_strengths_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "avatar", null: false
    t.string "username", null: false
    t.string "gender"
    t.integer "birth_year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "education"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "writings", force: :cascade do |t|
    t.string "title"
    t.text "entry"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_writings_on_user_id"
  end

  add_foreign_key "comments", "users"
  add_foreign_key "comments", "writings"
  add_foreign_key "concerns", "users"
  add_foreign_key "strengths", "users"
  add_foreign_key "writings", "users"
end
