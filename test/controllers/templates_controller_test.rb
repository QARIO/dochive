require 'test_helper'

class TemplatesControllerTest < ActionController::TestCase
  setup do
    @template = templates(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:templates)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create template" do
    assert_difference('Template.count') do
      post :create, template: { description: @template.description, filename: @template.filename, group_id: @template.group_id, name: @template.name, path: @template.path, style_id: @template.style_id, type_id: @template.type_id, url: @template.url, user_id: @template.user_id }
    end

    assert_redirected_to template_path(assigns(:template))
  end

  test "should show template" do
    get :show, id: @template
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @template
    assert_response :success
  end

  test "should update template" do
    patch :update, id: @template, template: { description: @template.description, filename: @template.filename, group_id: @template.group_id, name: @template.name, path: @template.path, style_id: @template.style_id, type_id: @template.type_id, url: @template.url, user_id: @template.user_id }
    assert_redirected_to template_path(assigns(:template))
  end

  test "should destroy template" do
    assert_difference('Template.count', -1) do
      delete :destroy, id: @template
    end

    assert_redirected_to templates_path
  end
end
