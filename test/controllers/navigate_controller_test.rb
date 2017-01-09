require 'test_helper'

class NavigateControllerTest < ActionController::TestCase
  test "should get start" do
    get :start
    assert_response :success
  end

end
