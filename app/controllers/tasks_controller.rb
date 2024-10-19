class TasksController < ApplicationController
    include AuthorizeRequest

    def new
      task = Task.new
    end

    def index
      task = @current_user.task_list.tasks
      render json: task, status: ok
    end

    def show
          task = Task.find_by(id: params[:taskId], task_list_id: params[:listId])
          if task
              render json: task, status: :ok
          else 
              render json: {error: 'Task not found'}, status: :not_found
          end
    end

    def create
      ActiveRecord::Base.transaction do
        task_list = TaskList.find(params[:listId])
        puts task_list.inspect
        task = task_list.tasks.build(task_params)
        if task.save!
          render json: {
            idTask: task.id,
            taskDescription: task.task_description,
            isTaskDone: task.is_task_done,
            createdAt: task.created_at,
            updatedAt: task.updated_at
          }, status: :created
        else 
            render json: {errors: task.errors.full_messages}, status: :unprocessable_entity
        end
      end
    rescue ActiveRecord::Rollback  
    end

    def update
        task = Task.find_by(task_list_id: params[:listId], id: params[:taskId])
        if task.update(task_params)
          render json: task, status: :ok
        else
          render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
    end

    def destroy
        task = Task.find_by(task_list_id: params[:listId], id: params[:taskId])
        task.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Task not found' }, status: :not_found
    end

    def task_params
      params.permit(:task_description, :is_task_done)
    end

end
