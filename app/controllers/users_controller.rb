class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [:signup, :login]
  # before_action :authorize_request, only: :profile

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

      if User.exists?(email: @user.email)
        render json: { error: 'Email already in use.' }, status: :conflict
        return 
      end

      if @user.save!
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
    unless params[:email].present? && params[:email].match?(URI::MailTo::EMAIL_REGEXP)
      render json: { error: 'Invalid email.' }, status: :unprocessable_entity
      return
    end

    unless params[:password].present? && params[:password].is_a?(String)
      render json: { error: 'Incorrect password or invalid format.' }, status: :unprocessable_entity
      return
    end

    @user = User.find_by(email: params[:email])

    if @user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Email not found or wrong password.' }, status: :not_found
    end
    
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :user_picture)
  end

end