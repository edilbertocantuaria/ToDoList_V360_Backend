Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  post "users/signup" => "users#signup", as: :user_signup
  post "users/login" => "users#login", as: :user_login
  get "users/profile" => "users#profile", as: :user_profile
  
  # resources :task_lists, path: 'task-lists', only: [:create, :index, :show, :update, :destroy]

  get "task-lists" => "task_lists#index", as: :task_lists_index 
  get "task-lists/:id" => "task_lists#show", as: :task_list 
  post "task-lists" => "task_lists#create", as: :create_task_list 
  put "task-lists/:id" => "task_lists#update", as: :update_task_list
  delete "task-lists/:id" => "task_lists#destroy", as: :destroy_task_list 

  get "task-lists/:listId/tasks/:taskId" => "tasks#show", as: :task
  post "task-lists/:listId/tasks" => "tasks#create", as: :create_task
  put "task-lists/:listId/tasks/:taskId" => "tasks#update", as: :update_task
  delete "task-lists/:listId/tasks/:taskId" => "tasks#destroy", as: :destroy_task

  get "tags" => "tags#index", as: :tags_index
  get "tags/:tagId" => "tags#show", as: :tags
  post "tags" => "tags#create", as: :create_tag
  put "tags/:tagId" => "tags#update", as: :update_tag
  delete "tags/:tagId" => "tags#destroy", as: :destroy_tag
end
