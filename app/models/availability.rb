class Availability < ApplicationRecord
  has_one :appointment, dependent: :destroy
  belongs_to :provider

  validates :source, presence: true
  validates :starts_at, presence: true
  validates :ends_at, presence: true
  validate :validates_ends_at_after_starts_at
  validate :validates_no_overlapping_time_slots

  scope :between_dates, ->(starts_at, ends_at) { where("starts_at > ? AND ends_at < ?", starts_at, ends_at) }

  private

  def validates_ends_at_after_starts_at
    return unless starts_at && ends_at

    if starts_at == ends_at
      errors.add(:ends_at, "cannot be equal to starts_at")
    elsif ends_at < starts_at
      errors.add(:ends_at, "must be after starts_at")
    end
  end

  def validates_no_overlapping_time_slots
    if overlapping.exists?
      errors.add(:base, "time slot overlaps with an existing slot for this provider")
    end
  end

  def overlapping
    Availability.where(provider_id:).where.not(id:).where("starts_at < ? AND ends_at > ?", ends_at, starts_at)
  end
end
