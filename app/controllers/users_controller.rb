class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:signup, :login]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def profile
    render json: {
      idUser: @current_user.id,
      name: @current_user.name,
      email: @current_user.email,
      userPicture: @current_user.user_picture,
      createdAt: @current_user.created_at
    }, status: :ok
  end

  def signup
    ActiveRecord::Base.transaction do
      @user = User.new(user_params)
      if @user.save!
        Rails.logger.info("User created successfully: #{@user.inspect}")
        render json: {
          idUser: @user.id,
          name: @user.name,
          email: @user.email,
          userPicture: @user.user_picture,
          createdAt: @user.created_at
        }, status: :created
      else
        render json: @user.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::Rollback
  end

  def login
    @user = User.find_by(email: params[:email])
    if @user&.authenticate(params[:password])
      Rails.logger.info("Login successful for user: #{@user.inspect}")
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      Rails.logger.info("Login failed: Invalid email or password")
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :user_picture)
  end

end