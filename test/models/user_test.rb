require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should not save user without name" do
    user = User.new(email: "test@example.com", password: "password123")
    assert_not user.save, "Saved the user without a name"
  end

  test "should not save user without email" do
    user = User.new(name: "Test User", password: "password123")
    assert_not user.save, "Saved the user without an email"
  end

  test "should not save user without password" do
    user = User.new(name: "Test User", email: "test@example.com")
    assert_not user.save, "Saved the user without a password"
  end

  test "should not save user with duplicate email" do
    existing_user = users(:one) 
    user = User.new(name: "Another User", email: existing_user.email, password: "password123")
    assert_not user.save, "Saved the user with a duplicate email"
  end

  test "should not save user with invalid email" do
    user = User.new(name: "Another User", email: "invalidemail", password: "password123")
    assert_not user.save, "Saved the user with an invalid email"
  end

  test "should not save user with invalid name" do
    user = User.new(name: 3.1415, email: "test@example.com", password: "password123")
    assert_not user.save, "Saved the user with an invalid email"
  end

  test "should not save user short password" do
    user = User.new(name: "Another User", email: "test@example.com", password: "123")
    assert_not user.save, "Saved the user with short password"
  end

  test "should not save user with invalid url at user_picture" do
    user = User.new(name: "Another User", email: "test@example.com", password: "password123", user_picture:"www.randompicture.com")
    assert_not user.save, "Saved the user with invalid url at user_picture"
  end

  test "should save user with valid attributes" do
    user = User.new(name: "Valid User", email: "valid@example.com", password: "password123")
    assert user.save, "Failed to save the user with valid attributes"
  end

  test "should save user with valid user_picture" do
    user = User.new(name: "Valid User", email: "valid@example.com", password: "password123", user_picture:"https://this-person-does-not-exist.com/img/avatar-gen4d7d1a21370be0121492737cf21c5f42.jpg")
    assert user.save, "Failed to save the user with valid attributes"
  end
end
