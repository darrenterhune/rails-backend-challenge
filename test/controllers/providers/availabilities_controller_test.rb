require "test_helper"

class Providers::AvailabilitiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @provider = providers(:one)
    @availabilities = availabilities(:one)
    @from = 1.minute.ago
    @to = 1.hour.from_now
  end

  test "GET /providers/:provider_id/availabilities returns availabilities" do
    get "/providers/#{@provider.id}/availabilities", params: { from: @from, to: @to }

    assert_response :success
    assert_equal "application/json; charset=utf-8", response.content_type
    assert_equal JSON.parse(response.body), [ @availabilities ].as_json
  end
end
