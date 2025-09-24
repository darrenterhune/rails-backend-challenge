class Appointment < ApplicationRecord
  belongs_to :availability
  belongs_to :client
  belongs_to :provider

  validates :availability_id, uniqueness: {
    scope: [ :client_id, :provider_id ],
    message: "is already booked for this client and provider"
  }

  scope :cancelled, -> { where.not(deleted_at: nil) }

  def cancelled?
    deleted_at.present?
  end

  def soft_delete!
    update_column(:deleted_at, DateTime.current)
  end
end
