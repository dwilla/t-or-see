class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :created_events, foreign_key: "creator_id", class_name: "Event"
  has_many :attendees
  has_many :attended_events, through: :attendees, source: :event
  has_many :managers
  has_many :managed_locations, through: :managers, source: :location

  scope :managers, -> { joins(:managers).distinct }
  scope :admins, -> { where(admin: true) }

  def display_name
    email.split("@").first
  end

  def manager?
    managed_locations.exists?
  end

  def admin?
    admin
  end
end
