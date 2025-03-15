class FixLocationIdInEvents < ActiveRecord::Migration[8.0]
  def change
    # Delete events without a location_id instead of creating a default location
    execute("DELETE FROM events WHERE location_id IS NULL")

    # Now make the column non-nullable
    change_column_null :events, :location_id, false
  end
end
