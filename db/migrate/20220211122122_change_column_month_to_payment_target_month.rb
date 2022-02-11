class ChangeColumnMonthToPaymentTargetMonth < ActiveRecord::Migration[7.0]
  def change
    change_column :payment_target_months, :month, :timestamp
  end
end
