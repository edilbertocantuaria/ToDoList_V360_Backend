require "test_helper"

class TagTest < ActiveSupport::TestCase
  def setup
    @user = User.create!(
      name: "Jose",
      email: "jose@example.com",
      password: "password789",
      password_confirmation: "password789",
      user_picture: "https://this-person-does-not-exist.com/img/avatar-gen55a4c0eee31e4ed8d9c618a9815c53cf.jpg"
    )

    @tag = Tag.create(tag_name: "Important", user_id: @user.id)
  end

  test "valid tag" do
    assert @tag.valid?
  end

  test "should not save tag without a tag_name" do
    @tag.tag_name = nil
    assert_not @tag.valid?
    assert_not_empty @tag.errors[:tag_name]
  end

  test "tag should belong to a user" do
    assert_equal @user, @tag.user
  end

  test "tag should have many task_lists" do
    task_list = TaskList.create!(title: "My Tasks", tag_id: @tag.id, user_id: @user.id)
    assert_includes @tag.task_lists, task_list
  end
end
