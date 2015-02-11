require 'test_helper'

class PagesControllerTest < ActionController::TestCase
  setup do
    @page = pages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create page" do
    assert_difference('Page.count') do
      post :create, page: { bottom: @page.bottom, document_id: @page.document_id, dpi: @page.dpi, exclude: @page.exclude, filename: @page.filename, height: @page.height, left: @page.left, modified: @page.modified, number: @page.number, path: @page.path, public: @page.public, right: @page.right, template_id: @page.template_id, templatex: @page.templatex, templatey: @page.templatey, top: @page.top, url: @page.url, user_id: @page.user_id, width: @page.width }
    end

    assert_redirected_to page_path(assigns(:page))
  end

  test "should show page" do
    get :show, id: @page
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @page
    assert_response :success
  end

  test "should update page" do
    patch :update, id: @page, page: { bottom: @page.bottom, document_id: @page.document_id, dpi: @page.dpi, exclude: @page.exclude, filename: @page.filename, height: @page.height, left: @page.left, modified: @page.modified, number: @page.number, path: @page.path, public: @page.public, right: @page.right, template_id: @page.template_id, templatex: @page.templatex, templatey: @page.templatey, top: @page.top, url: @page.url, user_id: @page.user_id, width: @page.width }
    assert_redirected_to page_path(assigns(:page))
  end

  test "should destroy page" do
    assert_difference('Page.count', -1) do
      delete :destroy, id: @page
    end

    assert_redirected_to pages_path
  end
end
