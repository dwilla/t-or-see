class BusinessHour < ApplicationRecord
  belongs_to :location

  enum :day, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }

  validates :day, presence: true
  validates :opens, presence: true
  validates :closes, presence: true
  validate :closes_after_opens

  def day_name
    day&.capitalize
  end

  private

  def closes_after_opens
    return if opens.blank? || closes.blank?

    if closes <= opens
      errors.add(:closes, "must be after opening time")
    end
  end
end
