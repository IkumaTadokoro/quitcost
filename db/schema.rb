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

ActiveRecord::Schema.define(version: 2022_04_02_061638) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "insurances", force: :cascade do |t|
    t.integer "year", comment: "年度"
    t.string "local_gov_code", comment: "地方公共団体コード"
    t.decimal "medical_income_basis", precision: 5, scale: 2, default: "0.0", comment: "医療保険分（所得割）"
    t.decimal "medical_asset_basis", precision: 5, scale: 2, default: "0.0", comment: "医療保険分（資産割）"
    t.integer "medical_capita_basis", default: 0, comment: "医療保険分（均等割）"
    t.integer "medical_household_basis", default: 0, comment: "医療保険分（平等割）"
    t.integer "medical_limit", default: 0, comment: "医療保険分限度額"
    t.decimal "elderly_income_basis", precision: 5, scale: 2, default: "0.0", comment: "後期高齢者支援金分(所得割)"
    t.decimal "elderly_asset_basis", precision: 5, scale: 2, default: "0.0", comment: "後期高齢者支援金分(資産割)"
    t.integer "elderly_capita_basis", default: 0, comment: "後期高齢者支援金分(均等割)"
    t.integer "elderly_household_basis", default: 0, comment: "後期高齢者支援金分(平等割)"
    t.integer "elderly_limit", default: 0, comment: "後期高齢者支援金分限度額"
    t.decimal "care_income_basis", precision: 5, scale: 2, default: "0.0", comment: "介護保険分(所得割)"
    t.decimal "care_asset_basis", precision: 5, scale: 2, default: "0.0", comment: "介護保険分(資産割)"
    t.integer "care_capita_basis", default: 0, comment: "介護保険分(均等割)"
    t.integer "care_household_basis", default: 0, comment: "介護保険分(平等割)"
    t.integer "care_limit", default: 0, comment: "介護保険分限度額"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["year", "local_gov_code"], name: "index_insurances_on_year_and_local_gov_code", unique: true
  end

  create_table "payment_target_months", force: :cascade do |t|
    t.datetime "month", precision: 6, comment: "年月"
    t.bigint "insurance_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "pensions", force: :cascade do |t|
    t.integer "year", null: false, comment: "年度"
    t.integer "contribution", null: false, comment: "国民年金保険料"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["year"], name: "index_pensions_on_year", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at", precision: 6
    t.datetime "remember_created_at", precision: 6
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "payment_target_months", "insurances"
end
