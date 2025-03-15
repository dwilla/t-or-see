namespace :admin do
  desc "Make a user an admin by email"
  task :grant, [ :email ] => :environment do |t, args|
    user = User.find_by(email: args[:email])

    if user.nil?
      puts "Error: User with email '#{args[:email]}' not found."
    elsif user.admin?
      puts "User '#{user.email}' is already an admin."
    else
      user.update(admin: true)
      puts "User '#{user.email}' is now an admin."
    end
  end

  desc "Remove admin privileges from a user by email"
  task :revoke, [ :email ] => :environment do |t, args|
    user = User.find_by(email: args[:email])

    if user.nil?
      puts "Error: User with email '#{args[:email]}' not found."
    elsif !user.admin?
      puts "User '#{user.email}' is not an admin."
    else
      user.update(admin: false)
      puts "Admin privileges removed from '#{user.email}'."
    end
  end

  desc "List all admin users"
  task list: :environment do
    admins = User.admins

    if admins.any?
      puts "Admin users:"
      puts "------------"
      admins.each do |admin|
        puts admin.email
      end
    else
      puts "No admin users found."
    end
  end

  desc "List all users"
  task users: :environment do
    users = User.all

    if users.any?
      puts "All users:"
      puts "----------"
      users.each do |user|
        roles = []
        roles << "ADMIN" if user.admin?
        roles << "Manager" if user.manager?

        puts "#{user.email} #{roles.any? ? '(' + roles.join(', ') + ')' : ''}"
      end
    else
      puts "No users found."
    end
  end

  desc "Generate admin documentation"
  task docs: :environment do
    # Create docs directory if it doesn't exist
    FileUtils.mkdir_p("docs")

    # Generate the admin documentation
    File.open("docs/admin.md", "w") do |file|
      file.puts "# Admin Documentation"
      file.puts
      file.puts "This document provides information about the admin functionality of the application."
      file.puts
      file.puts "## Admin Users"
      file.puts

      admins = User.admins
      if admins.any?
        file.puts "Current admin users:"
        file.puts
        admins.each do |admin|
          file.puts "- #{admin.email}"
        end
      else
        file.puts "No admin users found."
      end

      file.puts
      file.puts "## Locations"
      file.puts

      locations = Location.all
      if locations.any?
        file.puts "| Location | Managers |"
        file.puts "|----------|----------|"

        locations.each do |location|
          managers = location.users.map(&:email).join(", ")
          file.puts "| #{location.name} | #{managers.present? ? managers : 'None'} |"
        end
      else
        file.puts "No locations found."
      end

      file.puts
      file.puts "## Managers"
      file.puts

      managers = User.managers
      if managers.any?
        file.puts "| Manager | Managed Locations |"
        file.puts "|---------|------------------|"

        managers.each do |manager|
          locations = manager.managed_locations.map(&:name).join(", ")
          file.puts "| #{manager.email} | #{locations} |"
        end
      else
        file.puts "No managers found."
      end

      file.puts
      file.puts "## Admin Tasks"
      file.puts
      file.puts "### User Management"
      file.puts
      file.puts "```bash"
      file.puts "# Make a user an admin"
      file.puts "rails admin:grant[user@example.com]"
      file.puts
      file.puts "# Remove admin privileges from a user"
      file.puts "rails admin:revoke[user@example.com]"
      file.puts
      file.puts "# List all admin users"
      file.puts "rails admin:list"
      file.puts
      file.puts "# List all users"
      file.puts "rails admin:users"
      file.puts
      file.puts "# Generate this documentation"
      file.puts "rails admin:docs"
      file.puts "```"

      file.puts
      file.puts "### Location Management"
      file.puts
      file.puts "```bash"
      file.puts "# Assign a user as a manager to a location"
      file.puts "rails managers:assign[user@example.com,\"Location Name\"]"
      file.puts
      file.puts "# Remove a user as a manager from a location"
      file.puts "rails managers:remove[user@example.com,\"Location Name\"]"
      file.puts
      file.puts "# List all managers and their locations"
      file.puts "rails managers:list"
      file.puts "```"

      file.puts
      file.puts "## Events"
      file.puts

      events = Event.all
      if events.any?
        file.puts "| Event | Date | Location | Creator | Attendees |"
        file.puts "|-------|------|----------|---------|-----------|"

        events.each do |event|
          date = event.date.strftime("%Y-%m-%d")
          location = event.location&.name || "N/A"
          creator = event.creator&.email || "N/A"
          attendees = event.users.count

          file.puts "| #{event.title} | #{date} | #{location} | #{creator} | #{attendees} |"
        end
      else
        file.puts "No events found."
      end
    end

    puts "Admin documentation generated at docs/admin.md"
  end

  desc "Display admin dashboard in the terminal"
  task dashboard: :environment do
    puts "========================================"
    puts "           ADMIN DASHBOARD              "
    puts "========================================"
    puts

    # Admin Users
    puts "ADMIN USERS:"
    puts "------------"
    admins = User.admins
    if admins.any?
      admins.each do |admin|
        puts "- #{admin.email}"
      end
    else
      puts "No admin users found."
    end
    puts

    # Locations
    puts "LOCATIONS:"
    puts "----------"
    locations = Location.all
    if locations.any?
      locations.each do |location|
        puts "- #{location.name}"
        if location.users.any?
          puts "  Managers:"
          location.users.each do |user|
            puts "  - #{user.email}"
          end
        else
          puts "  No managers assigned"
        end
      end
    else
      puts "No locations found."
    end
    puts

    # Managers
    puts "MANAGERS:"
    puts "---------"
    managers = User.managers
    if managers.any?
      managers.each do |manager|
        puts "- #{manager.email}"
        puts "  Managed Locations:"
        manager.managed_locations.each do |location|
          puts "  - #{location.name}"
        end
      end
    else
      puts "No managers found."
    end
    puts

    # Events
    puts "EVENTS:"
    puts "-------"
    events = Event.all
    if events.any?
      events.each do |event|
        puts "- #{event.title} (#{event.date.strftime('%Y-%m-%d')})"
        puts "  Location: #{event.location&.name || 'N/A'}"
        puts "  Creator: #{event.creator&.email || 'N/A'}"
        puts "  Attendees: #{event.users.count}"
      end
    else
      puts "No events found."
    end
    puts

    puts "For more detailed information, run 'rails admin:docs'"
  end
end
