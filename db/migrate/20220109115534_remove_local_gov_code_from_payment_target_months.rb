class RemoveLocalGovCodeFromPaymentTargetMonths < ActiveRecord::Migration[7.0]
  def change
    remove_column :payment_target_months, :local_gov_code, :string
  end
end
