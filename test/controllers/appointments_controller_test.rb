require "test_helper"

class AppointmentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider = providers(:one)
    @client = clients(:one)
    @availability = availabilities(:three)
    @starts_at = 5.hours.from_now - 1.minutes
    @ends_at = 6.hours.from_now + 1.minutes
  end

  test "POST /appointments creates an appointment" do
    post "/appointments", params: { appointment: { client_id: @client.id, provider_id: @provider.id, starts_at: @starts_at, ends_at: @ends_at } }
    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
    appointment = JSON.parse(response.body)
    assert_equal @client.id, appointment["client_id"]
    assert_equal @provider.id, appointment["provider_id"]
    assert_equal @availability.id, appointment["availability_id"]
    assert_nil appointment["deleted_at"]
  end

  test "DELETE /appointments/:id cancels an appointment" do
    appointment = appointments(:two)
    delete "/appointments/#{appointment.id}"
    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
    assert_not_nil JSON.parse(response.body)["deleted_at"]
  end
end
