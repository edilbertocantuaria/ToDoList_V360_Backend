require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: "Jose",
      email: "jose@example.com",
      password: "password789", 
      password_confirmation: "password789", 
      user_picture: "https://this-person-does-not-exist.com/img/avatar-gen55a4c0eee31e4ed8d9c618a9815c53cf.jpg"
    )

    @token = JsonWebToken.encode(user_id: @user.id)
  end
  
  setup do
    @valid_user_params = {
      name: "John Doe",
      email: "johndoe@example.com",
      password: "password123",
      password_confirmation:"password123",
      user_picture: "https://example.com/picture.jpg"
    }
    
    @invalid_user_params = {
      name: "",
      email: "invalid_email",
      password: "123",
      password_confirmation:"password123",
      user_picture: "invalid_url"
    }
  end

  def json_response
    JSON.parse(@response.body)
  end

  ## SINGUP ##
  test "should signup user with valid params" do
    post user_signup_url, params: @valid_user_params 
    assert_response :created
  end

  test "should not signup user with invalid params" do
    post user_signup_url, params: @invalid_user_params 
    assert_response :unprocessable_entity

    assert_kind_of Array, json_response['errors']
    assert_includes json_response['errors'], "Name can't be blank"
    assert_includes json_response['errors'], "Email is invalid"
    assert_includes json_response['errors'], "Name Only alphabetic characters."
    assert_includes json_response['errors'], "Password is too short (minimum is 6 characters)"
    assert_includes json_response['errors'],  "User picture User picture must be an URL valid."
  end

  test "should not signup user when email conflicts" do
    existing_user = users(:one)
  
    post user_signup_url, params: {
      name: 'New User',
      email: existing_user.email,
      password: 'newPassword123123',
      password_confirmation: 'newPassword123123'
    }
  
    assert_response :conflict
    json_response = JSON.parse(response.body)
    assert_equal 'Email already in use.', json_response['error']
  end
  
  ## LOGIN ##
  test "should login with valid credentials" do
    user = users(:one) 

    post user_login_url, params: { email: @user.email, password: @user.password }
    assert_response :ok

    json_response = JSON.parse(response.body)
    assert json_response['token'].present?
  end

  test "should not login with non register email" do
    post user_login_url, params: { email: "wrong@example.com", password: "password" }
    assert_response :not_found
    assert_equal 'Email not found or wrong password.', json_response['error']
  end

  test "should not login with non valid email" do
    post user_login_url, params: { email: "wrongexample.com", password: "password" }
    assert_response :unprocessable_entity
    assert_equal 'Invalid email.', json_response['error']
  end

  test "should not login with incorrect password" do
    user = users(:one)
  
    post user_login_url, params: { email: user.email, password: "wrong_password" }
    assert_response :not_found
    assert_equal 'Email not found or wrong password.', json_response['error']
  end


  ## PROFILE ##
  test "should get user profile" do
    get user_profile_url, headers: { Authorization: "#{@token}"}
    assert_response :ok
  
    json_response = JSON.parse(response.body)
    assert_equal @user.id, json_response['idUser']
    assert_equal @user.name, json_response['name']
    assert_equal @user.email, json_response['email']
    assert_equal @user.user_picture, json_response['userPicture']
    assert_equal @user.created_at.as_json, json_response['createdAt'] 
  end
  
  test "should not get user profile" do
    get user_profile_url, headers: {}
    assert_response :unauthorized
  end

end

