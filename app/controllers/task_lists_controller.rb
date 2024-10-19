class TaskListsController < ApplicationController
    include AuthorizeRequest
    
    def new
      @task_list = TaskList.new
    end
  
    def index
      @task_lists = @current_user.task_lists.includes(:tasks) 
      render json: @task_lists.as_json(include: { tasks: { only: [:id, :task_description, :is_task_done] } }, methods: :percentage), status: :ok
    end

    def show
      @task_list = @current_user.task_lists.find(params[:id])
      render json: @task_list, status: :ok
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Task list not found' }, status: :not_found
    end
  
    def create
      ActiveRecord::Base.transaction do
        @task_list = @current_user.task_lists.build(task_list_params)
        if @task_list.save!
          render json: @task_list, status: :created
        else
          render json: { errors: @task_list.errors.full_messages }, status: :unprocessable_entity
          raise ActiveRecord::Rollback
        end
      end
    rescue ActiveRecord::Rollback
    end
  
    def update
      @task_list = @current_user.task_lists.find(params[:id])
      if @task_list.update(task_list_params)
        render json: @task_list, status: :ok
      else
        render json: { errors: @task_list.errors.full_messages }, status: :unprocessable_entity
      end
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Task list not found' }, status: :not_found
    end
  
    def destroy
      @task_list = @current_user.task_lists.find(params[:id])
      @task_list.destroy
      head :no_content
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Task list not found' }, status: :not_found
    end
  
    def task_list_params
      params.permit(:title, :idTag, :attachment).tap do |whitelisted|
        whitelisted[:tag_id] = params[:idTag] if params[:idTag].present?
      end
    end
  end
  