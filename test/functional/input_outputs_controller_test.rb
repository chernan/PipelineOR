require 'test_helper'

class InputOutputsControllerTest < ActionController::TestCase
  setup do
    @input_output = input_outputs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:input_outputs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create input_output" do
    assert_difference('InputOutput.count') do
      post :create, input_output: @input_output.attributes
    end

    assert_redirected_to input_output_path(assigns(:input_output))
  end

  test "should show input_output" do
    get :show, id: @input_output
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @input_output
    assert_response :success
  end

  test "should update input_output" do
    put :update, id: @input_output, input_output: @input_output.attributes
    assert_redirected_to input_output_path(assigns(:input_output))
  end

  test "should destroy input_output" do
    assert_difference('InputOutput.count', -1) do
      delete :destroy, id: @input_output
    end

    assert_redirected_to input_outputs_path
  end
end
