class AddTaglineAndDescriptionToLocations < ActiveRecord::Migration[8.0]
  def change
    add_column :locations, :tagline, :string, limit: 100
    add_column :locations, :description, :text
  end
end
