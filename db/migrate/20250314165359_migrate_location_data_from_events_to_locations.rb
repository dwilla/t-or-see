class MigrateLocationDataFromEventsToLocations < ActiveRecord::Migration[8.0]
  def up
    # Get unique locations from events
    locations = execute("SELECT DISTINCT location FROM events WHERE location IS NOT NULL AND location != ''").to_a

    # Create new location records and update events
    locations.each do |loc_hash|
      location_name = loc_hash['location']
      next if location_name.blank?

      # Create a new location record
      location = execute("INSERT INTO locations (name, created_at, updated_at) VALUES ('#{location_name}', '#{Time.current}', '#{Time.current}') RETURNING id").first

      # Update all events with this location to reference the new location record
      execute("UPDATE events SET location_id = #{location['id']} WHERE location = '#{location_name}'")
    end
  end

  def down
    # Revert the changes by copying location names back to events
    execute("UPDATE events SET location = (SELECT name FROM locations WHERE locations.id = events.location_id) WHERE location_id IS NOT NULL")

    # Clear location_id references
    execute("UPDATE events SET location_id = NULL")
  end
end
