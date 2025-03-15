# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create some default locations
locations = [
  { name: 'Conference Center', address: '123 Main St', city: 'San Francisco', state: 'CA', zip_code: '94105' },
  { name: 'Downtown Library', address: '456 Market St', city: 'San Francisco', state: 'CA', zip_code: '94103' },
  { name: 'Community Hall', address: '789 Mission St', city: 'San Francisco', state: 'CA', zip_code: '94107' },
  { name: 'Tech Campus', address: '101 Howard St', city: 'San Francisco', state: 'CA', zip_code: '94105' },
  { name: 'City Park', address: '200 Park Ave', city: 'San Francisco', state: 'CA', zip_code: '94110' }
]

locations.each do |location_attrs|
  Location.find_or_create_by!(name: location_attrs[:name]) do |location|
    location.assign_attributes(location_attrs)
  end
end

puts "Created #{Location.count} locations"

# If you have an admin user, make them a manager of all locations
if defined?(User) && User.exists?
  admin = User.first
  if admin
    # Make the first user an admin
    admin.update(admin: true) unless admin.admin?
    puts "Made #{admin.email} an admin"

    # Make the admin a manager of all locations
    Location.all.each do |location|
      Manager.find_or_create_by!(user: admin, location: location)
    end
    puts "Made #{admin.email} a manager of all locations"
  end
end
