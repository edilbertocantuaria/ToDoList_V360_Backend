class ApplicationController < ActionController::API
    before_action :authorize_request

    def authorize_request
      header = request.headers["Authorization"]
      token = header.split(" ").last if header

      if token.nil?
        render json: { errors: "Token not provided" }, status: :unauthorized
        return
      end

      begin
        @decoded = JsonWebToken.decode(token)
        @current_user = User.find(@decoded[:user_id])
      rescue ActiveRecord::RecordNotFound => e
        render json: { errors: "User not found" }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { errors: "Invalid token" }, status: :unauthorized
      end
    end
end
