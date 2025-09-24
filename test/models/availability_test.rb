require "test_helper"

class AvailabilityTest < ActiveSupport::TestCase
  setup do
    @availability = availabilities(:one)
  end

  test "should be valid with valid attributes" do
    assert @availability.valid?
  end

  test "should not be valid without starts_at" do
    @availability.starts_at = nil
    assert_not @availability.valid?
    assert_includes @availability.errors[:starts_at], "can't be blank"
  end

  test "should not be valid without ends_at" do
    @availability.ends_at = nil
    assert_not @availability.valid?
    assert_includes @availability.errors[:ends_at], "can't be blank"
  end

  test "should not be valid without source" do
    @availability.source = nil
    assert_not @availability.valid?
    assert_includes @availability.errors[:source], "can't be blank"
  end

  test "should not be valid if starts_at equals ends_at" do
    @availability.ends_at = @availability.starts_at
    assert_not @availability.valid?
    assert_includes @availability.errors[:ends_at], "cannot be equal to starts_at"
  end

  test "should not be valid if ends_at is before starts_at" do
    @availability.ends_at = @availability.starts_at - 1.hour
    assert_not @availability.valid?
    assert_includes @availability.errors[:ends_at], "must be after starts_at"
  end

  test "should not be valid if time slot overlaps with existing slot" do
    existing_slot = availabilities(:two)
    new_slot = Availability.new(
      provider: existing_slot.provider,
      starts_at: existing_slot.starts_at + 15.minutes,
      ends_at: existing_slot.ends_at - 15.minutes,
      source: "calendly"
    )
    assert_not new_slot.valid?
    assert_includes new_slot.errors[:base], "time slot overlaps with an existing slot for this provider"
  end

  test "should allow non-overlapping slots for the same provider" do
    existing_slot = availabilities(:one)
    new_slot = Availability.new(
      provider: existing_slot.provider,
      starts_at: existing_slot.ends_at + 1.hour,
      ends_at: existing_slot.ends_at + 2.hours,
      source: "calendly"
    )
    assert new_slot.valid?
  end

  test "should allow overlapping slots for different providers" do
    existing_slot = availabilities(:one)
    new_slot = Availability.new(
      provider: providers(:two),
      starts_at: existing_slot.starts_at,
      ends_at: existing_slot.ends_at,
      source: "calendly"
    )
    assert new_slot.valid?
  end
end
