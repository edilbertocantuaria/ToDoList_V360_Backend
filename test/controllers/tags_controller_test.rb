require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: "Jose",
      email: "jose@example.com",
      password: "password789",
      password_confirmation: "password789", 
      user_picture: "https://this-person-does-not-exist.com/img/avatar-gen55a4c0eee31e4ed8d9c618a9815c53cf.jpg"
    )
    
    @tag = @user.tags.create!(
      tag_name: "My tag"
    )

    @task_list = TaskList.create!(title: "My Task List", user_id: @user.id)
    
    @task = @task_list.tasks.create!(task_description: "First task", is_task_done: false)
    
    @headers = { Authorization: JsonWebToken.encode(user_id: @user.id) }
  end

  ## INDEX ##
  test "should return tags" do
    get tags_index_url, headers: @headers
    assert_response :ok
  end

  test "should not return tags" do
    get tags_index_url, headers: {}
    assert_response :unauthorized
  end


  ## SHOW ##
  test "should show a specific tag" do
    get tags_url(tagId:@tag.id), headers: @headers  # Usando o helper correto
    assert_response :ok
  end
  
  test "should return not found if tag does not exists" do
    get tags_url(tagId: 99), headers: @headers  # Usando o helper correto
    assert_response :not_found
  end

  test "should not return any tag" do
    get tags_url(tagId: @tag.id), headers:{}
    assert_response :unauthorized
  end

  ## CREATE ##
  test "should save a tag with valid params" do
    post create_tag_url, params: { tag: { tag_name: "My tag" } }, headers: @headers 
    assert_response :created
  end

  test "should not save a task list with invalid params" do
    post create_tag_url, params: { tag: { tag_name: "" } }, headers: @headers  
    assert_response :unprocessable_entity
  end

  test "should not save a tag list if no authenticated" do
    post create_tag_url, params: { tag: { tag_name: "" } }
    assert_response :unauthorized
  end

  ## UPDATE ##
  test "should update tag list with valid params" do
    put update_tag_url(tagId: @tag.id), params: { tag: { tag_name: "Editing tag" } }, headers: @headers  
    assert_response :ok
  end

  test "should not update task list that does not exist" do 
    put update_tag_url(tagId: 99), params: { tag: { tag_name: 'New Tag' } }, headers: @headers 
    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal 'Tag not found', json_response['error']  
  end
  
  test "should not update tag with invalid params" do
    put update_tag_url(tagId: @tag.id), params: { tag: { tag_name: "    " } }, headers: @headers  
    assert_response :unprocessable_entity
  end
  
  test "should not update tag if no authenticated" do
    put update_tag_url(tagId: @tag.id), params: { tag: { tag_name: "Editing tag" } }
    assert_response :unauthorized
  end

  ## DESTROY ##
  test "should delete tag" do
    delete destroy_tag_url(tagId: @tag.id), headers: @headers 
    assert_response :no_content
  end

  test "should not destroy tag that does not exit" do
    delete destroy_tag_url(tagId: 99), headers: @headers 
    assert_response :not_found
    json_response = JSON.parse(response.body)
    assert_equal 'Tag not found', json_response['error']
  end
  
  test "should not destroy tag if no authenticated" do
    delete destroy_tag_url(tagId:@tag.id)
    assert_response :unauthorized
  end

end
