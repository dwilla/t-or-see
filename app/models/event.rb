class Event < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :location
  has_many :attendees
  has_many :users, through: :attendees

  has_one_attached :poster

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
  validate :end_time_after_start_time, if: -> { start_time.present? && end_time.present? }

  scope :past, -> {
    where("date < ?", Date.current)
    .or(where("date = ? AND end_time < ?", Date.current, Time.current))
  }

  scope :upcoming, -> {
    where("date > ?", Date.current)
    .or(where("date = ? AND start_time > ?", Date.current, Time.current))
  }

  # Get the poster image, falling back to the location's image if not available
  def display_image
    if poster.attached?
      poster
    elsif location&.image&.attached?
      location.image
    else
      nil
    end
  end

  private

  def end_time_after_start_time
    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
