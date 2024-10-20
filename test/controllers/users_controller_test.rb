require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @user = User.create!(
      name: "Jose",
      email: "jose@exemple.com",
      password: "password789", 
      user_picture: "https://this-person-does-not-exist.com/img/avatar-gen55a4c0eee31e4ed8d9c618a9815c53cf.jpg"
    )
  end
  
  setup do
    @valid_user_params = {
      name: "John Doe",
      email: "johndoe@example.com",
      password: "password123",
      user_picture: "https://example.com/picture.jpg"
    }
    
    @invalid_user_params = {
      name: "",
      email: "invalid_email",
      password: "123",
      user_picture: "invalid_url"
    }
  end

  ##SINGUP
  test "should signup user with valid params" do
    assert_difference('User.count', 1) do
      post user_signup_url, params: { user: @valid_user_params }
    end
    assert_response :created
  end

  test "should not signup user with invalid params" do
    assert_no_difference('User.count') do
      post user_signup_url, params: { user: @invalid_user_params }
    end
    assert_response :unprocessable_entity
  end

  test "should not signup user when email conflicts" do
    existing_user = users(:one)
  
    post user_signup_url, params: { user:
      {
      name: 'Novo Usuário',
      email: existing_user.email,
      password: 'newPassword123123'
      }
    }
  
    assert_response :conflict
    json_response = JSON.parse(response.body)
    assert_equal 'Email already in use.', json_response['error']
  end
  

  ##LOGIN
  test "should login with valid credentials" do
    user = users(:one) 

    post user_login_url, params: { email: @user.email, password: @user.password }
    assert_response :ok

    json_response = JSON.parse(response.body)
    assert json_response['token'].present?
  end

  test "should not login with invalid email" do
    post user_login_url, params: { email: "wrong@example.com", password: "password" }
    assert_response :not_found
  end

  test "should not login with incorrect password" do
    user = users(:one)
  
    post user_login_url, params: { email: user.email, password: "wrong_password" }
    assert_response :not_found
  end
end

