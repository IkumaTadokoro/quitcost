class CreatePaymentTargetMonths < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_target_months do |t|
      t.string :local_gov_code, comment: '地方公共団体コード'
      t.date :month, comment: '年月'
      t.references :insurance, null: false, foreign_key: true, index: false

      t.timestamps
    end

    add_index :payment_target_months, %i[local_gov_code month], unique: true
  end
end
