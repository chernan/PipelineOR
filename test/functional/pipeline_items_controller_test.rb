require 'test_helper'

class PipelineItemsControllerTest < ActionController::TestCase
  setup do
    @pipeline_item = pipeline_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pipeline_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pipeline_item" do
    assert_difference('PipelineItem.count') do
      post :create, pipeline_item: @pipeline_item.attributes
    end

    assert_redirected_to pipeline_item_path(assigns(:pipeline_item))
  end

  test "should show pipeline_item" do
    get :show, id: @pipeline_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pipeline_item
    assert_response :success
  end

  test "should update pipeline_item" do
    put :update, id: @pipeline_item, pipeline_item: @pipeline_item.attributes
    assert_redirected_to pipeline_item_path(assigns(:pipeline_item))
  end

  test "should destroy pipeline_item" do
    assert_difference('PipelineItem.count', -1) do
      delete :destroy, id: @pipeline_item
    end

    assert_redirected_to pipeline_items_path
  end
end
