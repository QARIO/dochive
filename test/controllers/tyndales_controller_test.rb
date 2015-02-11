require 'test_helper'

class TyndalesControllerTest < ActionController::TestCase
  setup do
    @tyndale = tyndales(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tyndales)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create tyndale" do
    assert_difference('Tyndale.count') do
      post :create, tyndale: { enabled: @tyndale.enabled, full: @tyndale.full, short: @tyndale.short }
    end

    assert_redirected_to tyndale_path(assigns(:tyndale))
  end

  test "should show tyndale" do
    get :show, id: @tyndale
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @tyndale
    assert_response :success
  end

  test "should update tyndale" do
    patch :update, id: @tyndale, tyndale: { enabled: @tyndale.enabled, full: @tyndale.full, short: @tyndale.short }
    assert_redirected_to tyndale_path(assigns(:tyndale))
  end

  test "should destroy tyndale" do
    assert_difference('Tyndale.count', -1) do
      delete :destroy, id: @tyndale
    end

    assert_redirected_to tyndales_path
  end
end
