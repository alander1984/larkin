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

ActiveRecord::Schema.define(version: 20151210162815) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer "city_id"
    t.string  "rawline"
    t.string  "zip"
  end

  create_table "attaches", force: :cascade do |t|
    t.integer "import_id"
    t.string  "style"
    t.binary  "file_contents"
  end

  create_table "cities", force: :cascade do |t|
    t.string  "name"
    t.integer "state_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "name"
    t.string "phone"
  end

  create_table "countries", force: :cascade do |t|
    t.string "name"
  end

  create_table "imports", force: :cascade do |t|
    t.string   "attach_file_name"
    t.string   "attach_content_type"
    t.integer  "attach_file_size"
    t.datetime "attach_updated_at"
  end

  create_table "loads", force: :cascade do |t|
    t.datetime "date"
    t.integer  "worker_id"
    t.integer  "truck_id"
    t.integer  "timeshift_id"
    t.string   "status"
  end

  add_index "loads", ["timeshift_id"], name: "index_loads_on_timeshift_id", using: :btree
  add_index "loads", ["truck_id"], name: "index_loads_on_truck_id", using: :btree
  add_index "loads", ["worker_id"], name: "index_loads_on_worker_id", using: :btree

  create_table "orders", force: :cascade do |t|
    t.string   "number"
    t.integer  "client_id"
    t.integer  "address_id"
    t.integer  "origin_id"
    t.integer  "timeshift_id"
    t.integer  "load_id"
    t.datetime "prefdate"
    t.float    "volume"
    t.integer  "quantity"
    t.integer  "sort"
  end

  create_table "origins", force: :cascade do |t|
    t.string  "name"
    t.integer "address_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "code"
    t.string "name"
  end

  create_table "states", force: :cascade do |t|
    t.string  "name"
    t.integer "country_id"
  end

  create_table "timeshifts", force: :cascade do |t|
    t.string  "code"
    t.string  "name"
    t.integer "num"
  end

  create_table "trucks", force: :cascade do |t|
    t.string  "no"
    t.integer "volume"
  end

  create_table "workers", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "name"
  end

  add_index "workers", ["email"], name: "index_workers_on_email", unique: true, using: :btree
  add_index "workers", ["reset_password_token"], name: "index_workers_on_reset_password_token", unique: true, using: :btree

  create_table "workers_roles", id: false, force: :cascade do |t|
    t.integer "role_id"
    t.integer "worker_id"
  end

  add_index "workers_roles", ["role_id"], name: "index_workers_roles_on_role_id", using: :btree
  add_index "workers_roles", ["worker_id"], name: "index_workers_roles_on_worker_id", using: :btree

  add_foreign_key "addresses", "cities"
  add_foreign_key "cities", "states"
  add_foreign_key "loads", "timeshifts"
  add_foreign_key "loads", "trucks"
  add_foreign_key "loads", "workers"
  add_foreign_key "orders", "clients"
  add_foreign_key "orders", "loads"
  add_foreign_key "orders", "origins"
  add_foreign_key "orders", "timeshifts"
  add_foreign_key "origins", "addresses"
  add_foreign_key "states", "countries"
  add_foreign_key "workers_roles", "roles"
  add_foreign_key "workers_roles", "workers"
end
