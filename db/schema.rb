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

ActiveRecord::Schema.define(version: 2022_02_11_122122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", precision: 6, null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

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
    t.datetime "month", comment: "年月"
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

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "payment_target_months", "insurances"
end
