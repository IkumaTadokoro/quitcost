class ChangePentionToPension < ActiveRecord::Migration[7.0]
  def change
    rename_table :pentions, :pensions
  end
end
