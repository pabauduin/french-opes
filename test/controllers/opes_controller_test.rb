require "test_helper"

class OpesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get opes_index_url
    assert_response :success
  end
end
