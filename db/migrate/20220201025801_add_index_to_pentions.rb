class AddIndexToPentions < ActiveRecord::Migration[7.0]
  def change
    add_index :pentions, :year, unique: true
  end
end
