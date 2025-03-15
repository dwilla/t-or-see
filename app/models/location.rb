class Location < ApplicationRecord
  has_many :events
  has_many :managers
  has_many :users, through: :managers

  has_one_attached :image

  validates :name, presence: true

  def to_s
    name
  end
end
