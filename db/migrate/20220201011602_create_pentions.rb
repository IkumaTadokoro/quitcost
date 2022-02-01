class CreatePentions < ActiveRecord::Migration[7.0]
  def change
    create_table :pentions do |t|
      t.integer :year, null: false, comment: '年度'
      t.integer :contribution, null: false, comment: '国民年金保険料'

      t.timestamps
    end
  end
end
