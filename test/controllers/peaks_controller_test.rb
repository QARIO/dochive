require 'test_helper'

class PeaksControllerTest < ActionController::TestCase
  setup do
    @peak = peaks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:peaks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create peak" do
    assert_difference('Peak.count') do
      post :create, peak: { dimension: @peak.dimension, intensity: @peak.intensity, number: @peak.number, offset: @peak.offset, page_id: @peak.page_id }
    end

    assert_redirected_to peak_path(assigns(:peak))
  end

  test "should show peak" do
    get :show, id: @peak
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @peak
    assert_response :success
  end

  test "should update peak" do
    patch :update, id: @peak, peak: { dimension: @peak.dimension, intensity: @peak.intensity, number: @peak.number, offset: @peak.offset, page_id: @peak.page_id }
    assert_redirected_to peak_path(assigns(:peak))
  end

  test "should destroy peak" do
    assert_difference('Peak.count', -1) do
      delete :destroy, id: @peak
    end

    assert_redirected_to peaks_path
  end
end
