require "test_helper"

class JsonWebTokenTest < ActiveSupport::TestCase
  test "should encode and decode token" do
    payload = { user_id: 1 }
    token = JsonWebToken.encode(payload)
    decoded = JsonWebToken.decode(token)

    assert_equal payload[:user_id], decoded[:user_id]
  end

  test "should return nil for invalid token" do
    decoded = JsonWebToken.decode("invalid_token")
    assert_nil decoded
  end
end
