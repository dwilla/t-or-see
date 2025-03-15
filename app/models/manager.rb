class Manager < ApplicationRecord
  belongs_to :user
  belongs_to :location

  validates :user_id, uniqueness: { scope: :location_id, message: "is already a manager for this location" }
end
