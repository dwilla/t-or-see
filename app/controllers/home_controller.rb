class HomeController < ApplicationController
  def index
    @business_categories = Location.categories.keys.map { |k| [ k.titleize.gsub("_", "/"), k ] }
    set_weekend_dates
  end

  def events_choice
    # Variables needed for the events partial
    @weekend_start = Date.today.next_occurring(:saturday)
    @weekend_end = @weekend_start + 1.day
    render partial: "events_links"
  end

  def businesses_choice
    @business_categories = Location.categories.keys.map { |k| [ k.titleize.gsub("_", "/"), k ] }
    render partial: "businesses_links"
  end

  private

  def set_weekend_dates
    today = Date.current
    current_day = today.wday # 0 is Sunday, 1 is Monday, etc.

    if current_day.between?(1, 4) # Monday through Thursday
      # Find next Friday
      days_until_friday = 5 - current_day
      @weekend_start = today + days_until_friday.days
      @weekend_end = @weekend_start + 2.days # Sunday
    elsif current_day == 5 # Friday
      @weekend_start = today
      @weekend_end = today + 2.days # Sunday
    elsif current_day == 6 # Saturday
      @weekend_start = today
      @weekend_end = today + 1.day # Sunday
    else # Sunday
      @weekend_start = today
      @weekend_end = today
    end
  end
end
