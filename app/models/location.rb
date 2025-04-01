class Location < ApplicationRecord
  has_many :managers, dependent: :delete_all
  has_many :users, through: :managers
  has_many :events, dependent: :delete_all
  has_many :business_hours, dependent: :delete_all

  accepts_nested_attributes_for :business_hours,
                               reject_if: :all_blank,
                               allow_destroy: true

  has_one_attached :image

  attribute :category, :integer
  enum :category, {
    food_and_beverage: 0,
    hot_springs: 1,
    gallery: 2,
    retail: 3,
    recreation: 4,
    lodging: 5
  }, default: :food_beverage

  validates :name, presence: true
  validates :category, presence: true, inclusion: { in: categories.keys }
  validates :tagline, length: { maximum: 100 }

  def to_s
    name
  end

  def currently_open?
    current_day = Time.current.strftime("%A").downcase
    current_hours = business_hours.find_by(day: current_day)

    return false unless current_hours

    # Get current time in the application's time zone
    zone = Time.zone || "Central Time (US & Canada)"
    current_time = Time.current.in_time_zone(zone)

    # Create time objects for opens and closes in the application's time zone
    opens_time = Time.zone.local(
      current_time.year,
      current_time.month,
      current_time.day,
      current_hours.opens.hour,
      current_hours.opens.min
    )

    closes_time = Time.zone.local(
      current_time.year,
      current_time.month,
      current_time.day,
      current_hours.closes.hour,
      current_hours.closes.min
    )

    Rails.logger.debug "Current time (#{zone}): #{current_time}"
    Rails.logger.debug "Opens time (#{zone}): #{opens_time}"
    Rails.logger.debug "Closes time (#{zone}): #{closes_time}"

    current_time.between?(opens_time, closes_time)
  end
end
