class AddCategoryToLocations < ActiveRecord::Migration[8.0]
  def change
    add_column :locations, :category, :integer, null: false, default: 0
  end
end
