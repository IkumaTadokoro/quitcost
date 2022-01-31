class CreateInsurances < ActiveRecord::Migration[7.0]
  def change
    create_table :insurances do |t|
      t.integer :year, comment: "年度"
      t.string :local_gov_code, comment: "地方公共団体コード"
      t.decimal :medical_income_basis, comment: "医療保険分（所得割）", default: 0, precision: 5, scale: 2
      t.decimal :medical_asset_basis, comment: "医療保険分（資産割）", default: 0, precision: 5, scale: 2
      t.integer :medical_capita_basis, comment: "医療保険分（均等割）", default: 0
      t.integer :medical_household_basis, comment: "医療保険分（平等割）", default: 0
      t.integer :medical_limit, comment: "医療保険分限度額", default: 0
      t.decimal :elderly_income_basis, comment: "後期高齢者支援金分(所得割)", default: 0, precision: 5, scale: 2
      t.decimal :elderly_asset_basis, comment: "後期高齢者支援金分(資産割)", default: 0, precision: 5, scale: 2
      t.integer :elderly_capita_basis, comment: "後期高齢者支援金分(均等割)", default: 0
      t.integer :elderly_household_basis, comment: "後期高齢者支援金分(平等割)", default: 0
      t.integer :elderly_limit, comment: "後期高齢者支援金分限度額", default: 0
      t.decimal :care_income_basis, comment: "介護保険分(所得割)", default: 0, precision: 5, scale: 2
      t.decimal :care_asset_basis, comment: "介護保険分(資産割)", default: 0, precision: 5, scale: 2
      t.integer :care_capita_basis, comment: "介護保険分(均等割)", default: 0
      t.integer :care_household_basis, comment: "介護保険分(平等割)", default: 0
      t.integer :care_limit, comment: "介護保険分限度額", default: 0

      t.timestamps
    end

    add_index :insurances, %i[year local_gov_code], unique: true
  end
end
