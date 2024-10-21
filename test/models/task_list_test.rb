require "test_helper"

class TaskListTest < ActiveSupport::TestCase

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

    @user.tags.create!(tag_name: "User's tag")
  end

  test "should not save task list without title" do
    taskList = TaskList.new(title: "")
    assert_not taskList.save, "Saved the task list without a title"
  end


  test "should not save task list with an invalid URL" do
    taskList = TaskList.new(title: "My task list", attachment: "invalid_url")
    assert_not taskList.save, "Saved the task list with an invalid URL"
  end

  test "should not save task list with a tag that does not belong to the user" do
    invalid_tag = Tag.new(tag_name: "Invalid tag")
    task_list = TaskList.new(title: "My task list", user: @user, tag: invalid_tag) 
    assert_not task_list.save, "Saved the task list with a tag that does not belong to the user"
  end

  test "should save task list without tag" do
    task_list = TaskList.new(
      title: "Task list without tag", 
      user: @user, 
      attachment: "https://valid-url.com"
    )
    
    assert task_list.save, "Failed to save task list without a tag"
  end
  
  test "should save task list without attachment" do
    task_list = TaskList.new(
      title: "Task list without attachment", 
      user: @user
    )
    
    assert task_list.save, "Failed to save task list without an attachment"
  end
  
  test "should return correct percentage of completed tasks" do
    task_list = TaskList.create!(title: "Task list", user: @user)
    
    task_list.tasks.create!(task_description: "Task 1", is_task_done: true)
    task_list.tasks.create!(task_description: "Task 2", is_task_done: false)
    
    assert_equal 50.0, task_list.percentage, "Incorrect percentage of completed tasks"
  end

  test "should not save task list without user" do
    task_list = TaskList.new(
      title: "Task list without user",
      attachment: "https://valid-url.com"
    )
    
    assert_not task_list.save, "Saved the task list without a user"
  end
  
  test "should save task list with valid params" do
    task_list = TaskList.new(
      title: "My valid task list", 
      user: @user, 
      tag: nil, 
      attachment: "https://valid-url.com"
    )

    assert task_list.save, "Failed to save task list with valid params"
  end

  test "should save task list with a tag that belongs to the user" do
    @user.tags << @tag
  
    task_list = TaskList.new(
      title: "Task list with valid tag", 
      user: @user, 
      tag: @tag, 
      attachment: "https://valid-url.com"
    )
  
    assert task_list.save, "Failed to save task list with a valid tag that belongs to the user"
  end
end