require 'test_helper'

class HiveControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get overview" do
    get :overview
    assert_response :success
  end

  test "should get settings" do
    get :settings
    assert_response :success
  end

end
