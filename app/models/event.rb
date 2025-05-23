class Event < ApplicationRecord
  belongs_to :creator, class_name: "User"
  belongs_to :location
  has_many :attendees, dependent: :delete_all
  has_many :users, through: :attendees

  has_one_attached :poster

  attribute :cover, :integer
  enum :cover, { free: 0, paid: 1 }, default: :free

  validates :cover, presence: true, inclusion: { in: covers.keys }

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :location, presence: true
  validate :end_time_after_start_time, if: -> { start_time.present? && end_time.present? }

  scope :past, -> {
    where("date < ?", Date.current)
    .or(where("date = ? AND end_time < ?", Date.current, Time.current.strftime("%H:%M:%S")))
  }

  scope :upcoming, -> {
    where("date > ?", Date.current)
    .or(where("date = ? AND start_time > ?", Date.current, Time.current.strftime("%H:%M:%S")))
  }

  default_scope { order(date: :asc, start_time: :asc) }

  # falls back to the location's image if no event image
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
