# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_10_10_051308) do

  create_table "asset_sims", charset: "utf8mb4", force: :cascade do |t|
    t.integer "cash"
    t.integer "investment_asset"
    t.integer "income"
    t.integer "expense"
    t.integer "investment_ratio"
    t.float "investment_yield"
    t.float "inflation_ratio"
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_asset_sims_on_user_id"
  end

  create_table "events", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "asset_sim_id", null: false
    t.string "name"
    t.integer "age"
    t.integer "value"
    t.integer "term"
    t.string "remarks"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.text "description"
    t.boolean "isvalid"
    t.index ["asset_sim_id"], name: "index_events_on_asset_sim_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.date "birth"
    t.string "password_digest"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "asset_sims", "users"
  add_foreign_key "events", "asset_sims"
end
