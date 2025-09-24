class Provider < ApplicationRecord
  has_many :availabilities, dependent: :destroy
  has_many :appointments, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
end
