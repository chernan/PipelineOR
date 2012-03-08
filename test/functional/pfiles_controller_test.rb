require 'test_helper'

class PfilesControllerTest < ActionController::TestCase
  setup do
    @pfile = pfiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pfiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pfile" do
    assert_difference('Pfile.count') do
      post :create, pfile: @pfile.attributes
    end

    assert_redirected_to pfile_path(assigns(:pfile))
  end

  test "should show pfile" do
    get :show, id: @pfile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pfile
    assert_response :success
  end

  test "should update pfile" do
    put :update, id: @pfile, pfile: @pfile.attributes
    assert_redirected_to pfile_path(assigns(:pfile))
  end

  test "should destroy pfile" do
    assert_difference('Pfile.count', -1) do
      delete :destroy, id: @pfile
    end

    assert_redirected_to pfiles_path
  end
end
