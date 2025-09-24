require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  setup do
    @appointment = appointments(:one)
  end

  test "appointment belongs to one availability" do
    assert_equal availabilities(:one), @appointment.availability
  end

  test "should not allow duplicate appointment for same client, provider, and availability" do
    duplicate_appointment = Appointment.new(
      client_id: @appointment.client_id,
      provider_id: @appointment.provider_id,
      availability_id: @appointment.availability_id,
      deleted_at: nil
    )
    assert_not duplicate_appointment.valid?
    assert_includes duplicate_appointment.errors[:availability_id], "is already booked for this client and provider"
  end

  test "should allow appointment with different client for same provider and availability" do
    new_appointment = Appointment.new(
      client_id: clients(:two).id,
      provider_id: @appointment.provider_id,
      availability_id: @appointment.availability_id,
      deleted_at: nil
    )
    assert new_appointment.valid?, "Appointment should be valid with a different client"
  end

  test "should allow appointment with different provider for same client and availability" do
    new_appointment = Appointment.new(
      client_id: @appointment.client_id,
      provider_id: providers(:two).id,
      availability_id: @appointment.availability_id,
      deleted_at: nil
    )
    assert new_appointment.valid?, "Appointment should be valid with a different provider"
  end

  test "should allow appointment with different availability for same client and provider" do
    new_appointment = Appointment.new(
      client_id: @appointment.client_id,
      provider_id: @appointment.provider_id,
      availability_id: availabilities(:two).id,
      deleted_at: nil
    )
    assert new_appointment.valid?, "Appointment should be valid with a different availability"
  end

  test "cancelled? returns true when deleted_at is present" do
    @appointment.deleted_at = Time.current
    assert @appointment.cancelled?, "Appointment should be cancelled when deleted_at is set"
  end

  test "cancelled? returns false when deleted_at is nil" do
    @appointment.deleted_at = nil
    assert_not @appointment.cancelled?, "Appointment should not be cancelled when deleted_at is nil"
  end

  test "soft_delete! sets deleted_at to current time" do
    appointment = appointments(:one)
    assert_nil appointment.deleted_at
    appointment.soft_delete!
    assert_not_nil appointment.deleted_at
  end
end
