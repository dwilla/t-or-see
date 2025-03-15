namespace :managers do
  desc "Assign a user as a manager to a location"
  task :assign, [ :user_email, :location_name ] => :environment do |t, args|
    user = User.find_by(email: args[:user_email])
    location = Location.find_by(name: args[:location_name])

    if user.nil?
      puts "Error: User with email '#{args[:user_email]}' not found."
      next
    end

    if location.nil?
      puts "Error: Location with name '#{args[:location_name]}' not found."
      next
    end

    manager = Manager.find_or_create_by(user: user, location: location)

    if manager.persisted?
      puts "Successfully assigned #{user.email} as a manager of '#{location.name}'."
    else
      puts "Error: Could not assign manager. #{manager.errors.full_messages.join(', ')}"
    end
  end

  desc "List all managers and their locations"
  task list: :environment do
    puts "Managers and their locations:"
    puts "-----------------------------"

    User.joins(:managers).distinct.each do |user|
      puts "#{user.email}:"
      user.managed_locations.each do |location|
        puts "  - #{location.name}"
      end
    end
  end

  desc "Remove a user as a manager from a location"
  task :remove, [ :user_email, :location_name ] => :environment do |t, args|
    user = User.find_by(email: args[:user_email])
    location = Location.find_by(name: args[:location_name])

    if user.nil?
      puts "Error: User with email '#{args[:user_email]}' not found."
      next
    end

    if location.nil?
      puts "Error: Location with name '#{args[:location_name]}' not found."
      next
    end

    manager = Manager.find_by(user: user, location: location)

    if manager.nil?
      puts "Error: #{user.email} is not a manager of '#{location.name}'."
      next
    end

    if manager.destroy
      puts "Successfully removed #{user.email} as a manager of '#{location.name}'."
    else
      puts "Error: Could not remove manager."
    end
  end
end
