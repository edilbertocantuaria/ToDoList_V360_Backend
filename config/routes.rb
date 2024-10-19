Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "users/signup" => "users#signup", as: :user_signup
  post "users/login" => "users#login", as: :user_login
  get "users/profile" => "users#profile", as: :user_profile
  
end
