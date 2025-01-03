class UsersController < ApplicationController
  skip_before_action :authorize_request, only: [ :signup, :login ]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def profile
    task_list_count = @current_user.task_lists.count

    render json: {
      idUser: @current_user.id,
      name: @current_user.name,
      email: @current_user.email,
      userPicture: @current_user.user_picture,
      taskListsCreated: task_list_count,
      createdAt: @current_user.created_at
    }, status: :ok
  end

  def signup
    begin
      ActiveRecord::Base.transaction do
        @user = User.new(user_params)

        if User.exists?(email: @user.email)
          render json: { error: "Email already in use." }, status: :conflict
          return
        end

        if @user.save
          render json: {
            idUser: @user.id,
            name: @user.name,
            email: @user.email,
            userPicture: @user.user_picture,
            createdAt: @user.created_at
          }, status: :created
        else
          Rails.logger.info(@user.errors.full_messages)
          render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    rescue => e
      Rails.logger.error("Error creating user: #{e.message}")
      render json: { error: "An internal error occurred." }, status: :internal_server_error
    end
  end


  def login
    unless params[:email].present? && params[:email].match?(URI::MailTo::EMAIL_REGEXP)
      render json: { error: "Invalid email." }, status: :unprocessable_entity
      return
    end

    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: @user.id)
      render json: { token: token }, status: :ok
    else
      render json: { error: "Email not found or wrong password." }, status: :not_found
    end
  end

  def user_params
    params.permit(:name, :email, :password, :password_confirmation, :user_picture)
  end

  def format_errors(errors)
    errors.full_messages
  end
end
