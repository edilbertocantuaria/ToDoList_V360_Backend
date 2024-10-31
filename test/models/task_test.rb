require "test_helper"

class TaskTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Jose",
      email: "jose@example.com",
      password: "password789",
      password_confirmation: "password789",
      user_picture: "https://this-person-does-not-exist.com/img/avatar-gen55a4c0eee31e4ed8d9c618a9815c53cf.jpg"
    )

    @tag = @user.tags.create!(tag_name: "My tag")

    @task_list = TaskList.create!(title: "My Task List", tag_id: @tag.id, user_id: @user.id, attachment: "https://valid-url.com")
  end

  test "should not save task without task_description" do
    task = Task.new(task_list: @task_list, task_description: "")
    assert_not task.save, "Saved the task without a task description"
  end

  test "should not save task with short task_description" do
    task = Task.new(task_list: @task_list, task_description: "a")
    assert_not task.save, "Saved the task with a task description that is too short"
  end

  test "should save task with valid task_description" do
    task = Task.new(task_list: @task_list, task_description: "Valid task description")
    assert task.save, "Failed to save task with valid task_description"
  end

  test "should set default is_task_done to false" do
    task = Task.new(task_list: @task_list, task_description: "Task with no is_task_done set")
    task.save
    assert_not task.is_task_done, "Task is_task_done was not set to false by default"
  end

  test "should keep is_task_done as true if explicitly set" do
    task = Task.new(task_list: @task_list, task_description: "Task that is done", is_task_done: true)
    assert task.save, "Failed to save task"
    assert task.is_task_done, "Task is_task_done was not saved as true"
  end
end
