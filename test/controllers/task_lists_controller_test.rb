require "test_helper"

class TaskListsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: "Jose",
      email: "jose@example.com",
      password: "password789", 
      user_picture: "https://this-person-does-not-exist.com/img/avatar-gen55a4c0eee31e4ed8d9c618a9815c53cf.jpg"
    )

    @tag = @user.tags.create!(
      tag_name: "My tag"
    )

    @valid_task_list = TaskList.create!(title: "My Task List", tag_id:@tag.id, user_id: @user.id, attachment: "https://valid-url.com")
    
    @token = JsonWebToken.encode(user_id: @user.id)
    
    @headers = { Authorization: @token }
  end

  def json_response
    JSON.parse(@response.body)
  end
  
  ## INDEX ##
  test "should get all task lists" do
    get task_lists_index_url, headers: @headers
    assert_response :ok
    json_response = JSON.parse(response.body)
    assert_equal 1, json_response.length
  end

  test "should not get any task lists" do
    get task_lists_index_url
    assert_response :unauthorized
  end

  ## SHOW ##
  test "should get only one task lists" do
    get task_list_url(id:@valid_task_list.id), headers: @headers
    assert_response :ok
    json_response = JSON.parse(response.body)
    assert_equal 7, json_response.length
  end

  test "should return not found if task list does not exists" do
    get task_list_url(id: 99), headers: @headers
    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal 'Task list not found', json_response['error']
  end

  test "should not return get any task lists" do
    get task_list_url(id: 1)
    assert_response :unauthorized
  end

   ## CREATE ##
   test "should save a task list with valid params" do
    post create_task_list_url, params: { title: "New Task List", attachment: "https://another-valid-url.com", user_id: @user.id, tag_id: @tag.id }, headers: @headers 
    assert_response :created
  end

  test "should not save a task list with invalid URL format" do
    post create_task_list_url, params: { title: "New Task List", attachment: "invalid_url", user_id: @user.id, tag_id: @tag.id }, headers: @headers 
    assert_response :unprocessable_entity
  end

  test "should not save a task list with a tag that does not belong to the user" do
    invalid_tag = Tag.new(tag_name: "Invalid tag")
    post create_task_list_url, params: { title: "New Task List", attachment: "invalid_url", user_id: @user.id, tag_id: invalid_tag }, headers: @headers 
    assert_response :unprocessable_entity
  end

  test "should not save a task list with invalid params" do
    post create_task_list_url, params: { title: "" }, headers: @headers 
    assert_response :unprocessable_entity
  end

  test "should not save a task list if no authenticated" do
    post create_task_list_url, params: { title: "New Task List", attachment: "https://another-valid-url.com", user_id: @user.id } 
    assert_response :unauthorized
  end

 ## UPDATE ##
  test "should update task list with valid params" do
    put update_task_list_url(id: @valid_task_list.id), params: { title: "Editing Task List", attachment: "https://another-valid-url.com", user_id: @user.id, tag_id: @tag.id }, headers: @headers 
    assert_response :ok
  end

  test "should not update task list that does not exit" do
    put update_task_list_url(id:99), params: { title: "Editing Task List", attachment: "https://another-valid-url.com", user_id: @user.id, tag_id: @tag.id }, headers: @headers 
    assert_response :not_found
  end

  test "should not update task list with invalid params" do
    put update_task_list_url(id:@valid_task_list.id), params: { title: "", attachment: "https://another-valid-url.com", user_id: @user.id, tag_id: @tag.id }, headers: @headers 
    assert_response :unprocessable_entity
  end
  
  test "should not update task list if no authenticated" do
    put update_task_list_url(id:@valid_task_list.id), params: { title: "Editing task list", attachment: "https://another-valid-url.com", user_id: @user.id, tag_id: @tag.id }
    assert_response :unauthorized
  end

  ## DESTROY ##
  test "should delete task list with valid params" do
    delete destroy_task_list_url(id: @valid_task_list.id), params: { title: "Editing Task List", attachment: "https://another-valid-url.com", user_id: @user.id, tag_id: @tag.id }, headers: @headers 
    assert_response :no_content
  end

  test "should not destroy task list that does not exit" do
    delete destroy_task_list_url(id:99), params: { title: "Editing Task List", attachment: "https://another-valid-url.com", user_id: @user.id, tag_id: @tag.id }, headers: @headers 
    assert_response :not_found
  end
  
  test "should not destroy task list if no authenticated" do
    delete destroy_task_list_url(id:@valid_task_list.id), params: { title: "Editing task list", attachment: "https://another-valid-url.com", user_id: @user.id, tag_id: @tag.id }
    assert_response :unauthorized
  end
end
