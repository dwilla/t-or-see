class SetDefaultCategoryForExistingLocations < ActiveRecord::Migration[8.0]
  def up
    # Cetegory default
    Location.where(category: nil).update_all(category: 0)
  end

  def down
  end
end
