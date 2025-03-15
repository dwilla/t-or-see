class MakeLocationIdNonNullableInEvents < ActiveRecord::Migration[8.0]
  def change
    # Create a default location for any events that might not have a location
    reversible do |dir|
      dir.up do
        # Check if there are any events without a location_id
        events_without_location = execute("SELECT COUNT(*) FROM events WHERE location_id IS NULL").first['count'].to_i

        if events_without_location > 0
          # Create a default location
          default_location = execute("INSERT INTO locations (name, created_at, updated_at) VALUES ('Default Location', '#{Time.current}', '#{Time.current}') RETURNING id").first

          # Assign the default location to events without a location
          execute("UPDATE events SET location_id = #{default_location['id']} WHERE location_id IS NULL")
        end
      end
    end

    # Now make the column non-nullable
    change_column_null :events, :location_id, false
  end
end
