require "test_helper"

class TasksControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: "Jose",
      email: "jose@example.com",
      password: "password789",
      password_confirmation: "password789",
      user_picture: "https://this-person-does-not-exist.com/img/avatar-gen55a4c0eee31e4ed8d9c618a9815c53cf.jpg"
    )

    @task_list = TaskList.create!(title: "My Task List", user_id: @user.id)
    @task = @task_list.tasks.create!(task_description: "First task", is_task_done: false)
    @headers = { Authorization: JsonWebToken.encode(user_id: @user.id) }
  end

  ## SHOW ##
  test "should show a specific task" do
    get task_url(listId: @task_list.id, taskId: @task.id), headers: @headers
    assert_response :ok
  end

  test "should return not found if task does not exists" do
    get task_url(listId: @task_list.id, taskId: 99), headers: @headers
    assert_response :not_found
  end

  test "should not return any task" do
    get task_url(listId: @task_list.id, taskId: @task.id)
    assert_response :unauthorized
  end

  ## CREATE ##
  test "should save a task with valid params" do
    post create_task_url(listId: @task_list.id), params: { tasks: [ { task_description: "First task", is_task_done: false } ] }, headers: @headers
    assert_response :created
  end

  test "should not save a task list with invalid params" do
    post create_task_url(listId: @task_list.id), params: { tasks: { task_description: "" } }, headers: @headers
    assert_response :unprocessable_entity
  end

  test "should not save a task if task list does not exist" do
    post create_task_url(listId: 99), params: { task_description: "First task", is_task_done: false }, headers: @headers
    assert_response :not_found
  end

  test "should not save a task list if no authenticated" do
    post create_task_url(listId: @task_list.id), params: { task_description: "First task", is_task_done: false }
    assert_response :unauthorized
  end

  ## UPDATE ##
  test "should update task with valid params" do
    put update_task_url(listId: @task_list.id, taskId: @task.id), params: { task_description: "Second task", is_task_done: true }, headers: @headers
    assert_response :ok
  end

  test "should not update task that does not exist" do
    put update_task_url(listId: @task_list.id, taskId: 99), params: { task_description: "Second task", is_task_done: true }, headers: @headers
    assert_response :not_found
  end

  test "should not update task if task list does not exist" do
    put update_task_url(listId: 99, taskId: 99), params: { task_description: "Second task", is_task_done: true }, headers: @headers
    assert_response :not_found
  end

  test "should not update task list with invalid params" do
    put update_task_url(listId: @task_list.id, taskId: @task.id), params: { task_description: "", is_task_done: true }, headers: @headers
    assert_response :unprocessable_entity
  end

  test "should not update task if no authenticated" do
    put update_task_url(listId: @task_list.id, taskId: @task.id), params: { task_description: "Second task", is_task_done: true }, headers: {}
    assert_response :unauthorized
  end

  test "should change percentage when update task status" do
    new_task_list = TaskList.create!(title: "New Task List", user_id: @user.id)

    task1 = new_task_list.tasks.create!(task_description: "Task 1", is_task_done: false)
    task2 = new_task_list.tasks.create!(task_description: "Task 2", is_task_done: false)

    put update_task_url(listId: new_task_list.id, taskId: task1.id),
        params: { task_description: "Task 1", is_task_done: true },
        headers: @headers

    assert_response :ok

    new_task_list.reload

    expected_percentage = 50.0

    assert_equal expected_percentage, new_task_list.percentage, "Completion percentage should be updated"
  end

  test "should return correct percentage of completed tasks" do
    new_task_list = TaskList.create!(title: "New Task List", user_id: @user.id)

    new_task_list.tasks.create!(task_description: "Task 1", is_task_done: false)
    new_task_list.tasks.create!(task_description: "Task 2", is_task_done: true)
    new_task_list.tasks.create!(task_description: "Task 3", is_task_done: true)

    new_task_list.reload

    expected_percentage = 66.67
    assert_equal expected_percentage, new_task_list.percentage, "Completion percentage should be 66.67%"
  end

  ## DESTROY ##
  test "should delete task with valid params" do
    delete destroy_task_url(listId: @task_list.id, taskId: @task.id), headers: @headers
    assert_response :no_content
  end

  test "should not destroy task that does not exist" do
    delete destroy_task_url(listId: @task_list.id, taskId: 99), headers: @headers
    assert_response :not_found
  end

  test "should not destroy task if task list does not exist" do
    delete destroy_task_url(listId: 99, taskId: 99), headers: @headers
    assert_response :not_found
  end

  test "should not destroy task if no authenticated" do
    delete destroy_task_url(listId: @task_list.id, taskId: @task.id)
    assert_response :unauthorized
  end
end
