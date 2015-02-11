require 'test_helper'

class AssetsControllerTest < ActionController::TestCase
  setup do
    @asset = assets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:assets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create asset" do
    assert_difference('Asset.count') do
      post :create, asset: { document_id: @asset.document_id, filename: @asset.filename, language: @asset.language, page_id: @asset.page_id, path: @asset.path, section_id: @asset.section_id, tfilename: @asset.tfilename, tpath: @asset.tpath, turl: @asset.turl, url: @asset.url, value: @asset.value }
    end

    assert_redirected_to asset_path(assigns(:asset))
  end

  test "should show asset" do
    get :show, id: @asset
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @asset
    assert_response :success
  end

  test "should update asset" do
    patch :update, id: @asset, asset: { document_id: @asset.document_id, filename: @asset.filename, language: @asset.language, page_id: @asset.page_id, path: @asset.path, section_id: @asset.section_id, tfilename: @asset.tfilename, tpath: @asset.tpath, turl: @asset.turl, url: @asset.url, value: @asset.value }
    assert_redirected_to asset_path(assigns(:asset))
  end

  test "should destroy asset" do
    assert_difference('Asset.count', -1) do
      delete :destroy, id: @asset
    end

    assert_redirected_to assets_path
  end
end
