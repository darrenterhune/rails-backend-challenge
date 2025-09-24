require "test_helper"

class ProviderTest < ActiveSupport::TestCase
  test "should be valid with valid attributes" do
    client = providers(:one)
    assert client.valid?
  end

  test "should not be valid without a name" do
    client = providers(:one)
    client.name = nil
    assert_not client.valid?
    assert_includes client.errors[:name], "can't be blank"
  end

  test "should not be valid without an email" do
    client = providers(:one)
    client.email = nil
    assert_not client.valid?
    assert_includes client.errors[:email], "can't be blank"
  end

  test "should not be valid with an invalid email format" do
    client = providers(:one)
    client.email = "invalid_email"
    assert_not client.valid?
    assert_includes client.errors[:email], "is invalid"
  end

  test "should be valid with a properly formatted email" do
    client = providers(:one)
    client.email = "test@example.com"
    assert client.valid?
  end
end
