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

ActiveRecord::Schema.define(version: 20190814151618) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_type"
    t.integer  "resource_id"
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "member_beer_payments", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "amount"
    t.string   "changed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_beer_payments_on_member_id", using: :btree
  end

  create_table "member_payments", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "amount"
    t.string   "changed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_payments_on_member_id", using: :btree
  end

  create_table "member_penalties", force: :cascade do |t|
    t.integer  "member_id"
    t.integer  "penalty_id"
    t.integer  "amount"
    t.string   "changed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["member_id"], name: "index_member_penalties_on_member_id", using: :btree
    t.index ["penalty_id"], name: "index_member_penalties_on_penalty_id", using: :btree
  end

  create_table "members", force: :cascade do |t|
    t.string   "name"
    t.integer  "current_money_penalties", default: 0
    t.integer  "current_beer_penalties",  default: 0
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "member_type"
  end

  create_table "penalties", force: :cascade do |t|
    t.string   "penalty_name"
    t.integer  "penalty_cost"
    t.integer  "case_of_beer_cost"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_foreign_key "member_penalties", "members"
  add_foreign_key "member_penalties", "penalties"
end
