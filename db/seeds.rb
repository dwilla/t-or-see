# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create admin user if it doesn't exist
admin_email = ENV.fetch("ADMIN_EMAIL", "admin@example.com")
admin_password = ENV.fetch("ADMIN_PASSWORD", "password123") # Only used in development/test

admin = User.find_or_create_by!(email: admin_email) do |user|
  user.password = admin_password
  user.admin = true
end
puts "Created admin user: #{admin.email}"

# Create sample locations with business hours
locations = [
  # Art Galleries
  {
    name: "303 Gallery",
    address: "303 Main Street",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "gallery",
    description: "Fine art gallery featuring the Peter Bowles mural and showcasing jewelry, antiques, and collectibles.",
    tagline: "Where art meets history",
    business_hours: [
      { day: 1, opens: "10:00", closes: "17:00" }, # Monday
      { day: 2, opens: "10:00", closes: "17:00" }, # Tuesday
      { day: 3, opens: "10:00", closes: "17:00" }, # Wednesday
      { day: 4, opens: "10:00", closes: "17:00" }, # Thursday
      { day: 5, opens: "10:00", closes: "17:00" }, # Friday
      { day: 6, opens: "10:00", closes: "17:00" }, # Saturday
      { day: 0, opens: "12:00", closes: "17:00" }  # Sunday
    ]
  },
  {
    name: "Artist Abbey",
    address: "Main Street",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "gallery",
    description: "Original art gallery featuring works from outsider to devotional, folk to conceptual, plus live shows and events.",
    tagline: "Where creativity comes alive",
    business_hours: [
      { day: 1, opens: "11:00", closes: "17:00" }, # Monday
      { day: 2, opens: "11:00", closes: "17:00" }, # Tuesday
      { day: 3, opens: "11:00", closes: "17:00" }, # Wednesday
      { day: 4, opens: "11:00", closes: "17:00" }, # Thursday
      { day: 5, opens: "11:00", closes: "17:00" }, # Friday
      { day: 6, opens: "11:00", closes: "17:00" }, # Saturday
      { day: 0, opens: "12:00", closes: "17:00" }  # Sunday
    ]
  },
  {
    name: "Rio Bravo Fine Art Gallery",
    address: "Main Street",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "gallery",
    description: "A spacious gallery and gift shop showing work by artists and artisans of the region.",
    tagline: "Regional art at its finest",
    business_hours: [
      { day: 1, opens: "10:00", closes: "17:00" }, # Monday
      { day: 2, opens: "10:00", closes: "17:00" }, # Tuesday
      { day: 3, opens: "10:00", closes: "17:00" }, # Wednesday
      { day: 4, opens: "10:00", closes: "17:00" }, # Thursday
      { day: 5, opens: "10:00", closes: "17:00" }, # Friday
      { day: 6, opens: "10:00", closes: "17:00" }, # Saturday
      { day: 0, opens: "12:00", closes: "17:00" }  # Sunday
    ]
  },

  # Retail & Antiques
  {
    name: "A Touch of Yesterday",
    address: "Downtown",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "retail",
    description: "A collectors paradise — new, antique and vintage items plus decor for every holiday.",
    tagline: "Yesterday's treasures, today's decor",
    business_hours: [
      { day: 1, opens: "10:00", closes: "17:00" }, # Monday
      { day: 2, opens: "10:00", closes: "17:00" }, # Tuesday
      { day: 3, opens: "10:00", closes: "17:00" }, # Wednesday
      { day: 4, opens: "10:00", closes: "17:00" }, # Thursday
      { day: 5, opens: "10:00", closes: "17:00" }, # Friday
      { day: 6, opens: "10:00", closes: "17:00" }, # Saturday
      { day: 0, opens: "12:00", closes: "17:00" }  # Sunday
    ]
  },
  {
    name: "Angel Remnants",
    address: "Main Street",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "retail",
    description: "Resale items, original art by Marcia McCoy and LyndaStar, gemstone angels by LyndaStar.",
    tagline: "Where angels and art meet",
    business_hours: [
      { day: 1, opens: "10:00", closes: "17:00" }, # Monday
      { day: 2, opens: "10:00", closes: "17:00" }, # Tuesday
      { day: 3, opens: "10:00", closes: "17:00" }, # Wednesday
      { day: 4, opens: "10:00", closes: "17:00" }, # Thursday
      { day: 5, opens: "10:00", closes: "17:00" }, # Friday
      { day: 6, opens: "10:00", closes: "17:00" }, # Saturday
      { day: 0, opens: "12:00", closes: "17:00" }  # Sunday
    ]
  },

  # Food & Beverage
  {
    name: "Bullock's Grocery",
    address: "Downtown",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "food_and_beverage",
    description: "Truth or Consequences' beloved downtown grocery store.",
    tagline: "Your local grocery store",
    business_hours: [
      { day: 1, opens: "07:00", closes: "20:00" }, # Monday
      { day: 2, opens: "07:00", closes: "20:00" }, # Tuesday
      { day: 3, opens: "07:00", closes: "20:00" }, # Wednesday
      { day: 4, opens: "07:00", closes: "20:00" }, # Thursday
      { day: 5, opens: "07:00", closes: "20:00" }, # Friday
      { day: 6, opens: "07:00", closes: "20:00" }, # Saturday
      { day: 0, opens: "07:00", closes: "20:00" }  # Sunday
    ]
  },
  {
    name: "Passion Pie Cafe",
    address: "Main Street",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "food_and_beverage",
    description: "An array of baked goods to take with or eat in the restaurant.",
    tagline: "Sweet treats and savory delights",
    business_hours: [
      { day: 1, opens: "08:00", closes: "15:00" }, # Monday
      { day: 2, opens: "08:00", closes: "15:00" }, # Tuesday
      { day: 3, opens: "08:00", closes: "15:00" }, # Wednesday
      { day: 4, opens: "08:00", closes: "15:00" }, # Thursday
      { day: 5, opens: "08:00", closes: "15:00" }, # Friday
      { day: 6, opens: "08:00", closes: "15:00" }, # Saturday
      { day: 0, opens: "08:00", closes: "15:00" }  # Sunday
    ]
  },

  # Hot Springs
  {
    name: "Charles Motel & Hotsprings",
    address: "Main Street",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "hot_springs",
    description: "The lobby gift shop sells pottery, cards, jewelry, minerals, stones, textiles, and other hand-made items.",
    tagline: "Relax in natural hot springs",
    business_hours: [
      { day: 1, opens: "08:00", closes: "22:00" }, # Monday
      { day: 2, opens: "08:00", closes: "22:00" }, # Tuesday
      { day: 3, opens: "08:00", closes: "22:00" }, # Wednesday
      { day: 4, opens: "08:00", closes: "22:00" }, # Thursday
      { day: 5, opens: "08:00", closes: "22:00" }, # Friday
      { day: 6, opens: "08:00", closes: "22:00" }, # Saturday
      { day: 0, opens: "08:00", closes: "22:00" }  # Sunday
    ]
  },
  {
    name: "Sierra Grande",
    address: "Main Street",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "hot_springs",
    description: "A hot springs hotel offering lodging, full spa services, hot springs, and dining in the heart of downtown T or C.",
    tagline: "Luxury hot springs resort",
    business_hours: [
      { day: 1, opens: "00:00", closes: "23:59" }, # Monday
      { day: 2, opens: "00:00", closes: "23:59" }, # Tuesday
      { day: 3, opens: "00:00", closes: "23:59" }, # Wednesday
      { day: 4, opens: "00:00", closes: "23:59" }, # Thursday
      { day: 5, opens: "00:00", closes: "23:59" }, # Friday
      { day: 6, opens: "00:00", closes: "23:59" }, # Saturday
      { day: 0, opens: "00:00", closes: "23:59" }  # Sunday
    ]
  },

  # Recreation
  {
    name: "Zia Kayak Outfitters",
    address: "Elephant Butte",
    city: "Elephant Butte",
    state: "NM",
    zip_code: "87935",
    category: "recreation",
    description: "Kayak, paddleboard and other watercraft sales, plus fishing supplies.",
    tagline: "Your water adventure headquarters",
    business_hours: [
      { day: 1, opens: "09:00", closes: "17:00" }, # Monday
      { day: 2, opens: "09:00", closes: "17:00" }, # Tuesday
      { day: 3, opens: "09:00", closes: "17:00" }, # Wednesday
      { day: 4, opens: "09:00", closes: "17:00" }, # Thursday
      { day: 5, opens: "09:00", closes: "17:00" }, # Friday
      { day: 6, opens: "09:00", closes: "17:00" }, # Saturday
      { day: 0, opens: "09:00", closes: "17:00" }  # Sunday
    ]
  },
  {
    name: "Morning Star Outfitters",
    address: "Main Street",
    city: "Truth or Consequences",
    state: "NM",
    zip_code: "87901",
    category: "recreation",
    description: "Stop in for sporting goods, sunscreen, ice cream, and bike rentals.",
    tagline: "Your outdoor adventure store",
    business_hours: [
      { day: 1, opens: "09:00", closes: "17:00" }, # Monday
      { day: 2, opens: "09:00", closes: "17:00" }, # Tuesday
      { day: 3, opens: "09:00", closes: "17:00" }, # Wednesday
      { day: 4, opens: "09:00", closes: "17:00" }, # Thursday
      { day: 5, opens: "09:00", closes: "17:00" }, # Friday
      { day: 6, opens: "09:00", closes: "17:00" }, # Saturday
      { day: 0, opens: "09:00", closes: "17:00" }  # Sunday
    ]
  }
]

# Create locations and their business hours
locations.each do |location_data|
  business_hours = location_data.delete(:business_hours)

  location = Location.find_or_create_by!(
    name: location_data[:name],
    address: location_data[:address],
    city: location_data[:city],
    state: location_data[:state],
    zip_code: location_data[:zip_code],
    category: location_data[:category],
    description: location_data[:description],
    tagline: location_data[:tagline]
  )

  puts "Created/Updated location: #{location.name}"

  # Create business hours for the location
  business_hours.each do |hour_data|
    BusinessHour.find_or_create_by!(
      location: location,
      day: hour_data[:day]
    ) do |hour|
      hour.opens = hour_data[:opens]
      hour.closes = hour_data[:closes]
    end
  end
end

# Create sample events
events = [
  {
    title: "First Friday Art Walk",
    description: "Monthly art walk featuring local artists and galleries.",
    start_time: Time.current.beginning_of_month.next_month.beginning_of_week(:friday) + 17.hours,
    end_time: Time.current.beginning_of_month.next_month.beginning_of_week(:friday) + 20.hours,
    location: Location.find_by(name: "303 Gallery"),
    creator: admin
  },
  {
    title: "Hot Springs Festival",
    description: "Annual celebration of Truth or Consequences' hot springs heritage.",
    start_time: Time.current.beginning_of_month.next_month.beginning_of_week(:saturday) + 10.hours,
    end_time: Time.current.beginning_of_month.next_month.beginning_of_week(:saturday) + 17.hours,
    location: Location.find_by(name: "Sierra Grande"),
    creator: admin
  }
]

events.each do |event_data|
  Event.find_or_create_by!(
    title: event_data[:title],
    start_time: event_data[:start_time]
  ) do |event|
    event.description = event_data[:description]
    event.end_time = event_data[:end_time]
    event.location = event_data[:location]
    event.creator = event_data[:creator]
  end
  puts "Created/Updated event: #{event_data[:title]}"
end

puts "\nSeed completed successfully!"
puts "Admin email: admin@example.com"
puts "Admin password: password123"
