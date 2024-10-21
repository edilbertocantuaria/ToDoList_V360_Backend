class TasksController < ApplicationController
  include AuthorizeRequest

  def new
    task = Task.new
  end

  def index
    tasks = @current_user.task_list.tasks
    render json: tasks.map { |task| format_task(task) }, status: :ok
  end

  def show
    task = Task.find_by(id: params[:taskId], task_list_id: params[:listId])
    if task
      render json: format_task(task), status: :ok
    else
      render json: { error: 'Task not found' }, status: :not_found
    end
  end

  def create
    ActiveRecord::Base.transaction do
      task_list = TaskList.find(params[:listId])

      unless task_list
        render json: { error: 'Task list not found' }, status: :not_found
        return
      end

      task = task_list.tasks.build(task_params)

      if task.save!
        render json: format_task(task), status: :created
      else
        render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
       end
    end
  rescue ActiveRecord::Rollback  
  end

  def update
    task = Task.find_by(task_list_id: params[:listId], id: params[:taskId])

    unless task
      render json: { error: 'Task not found' }, status: :not_found
      return
    end

    if task.update(task_params)
      render json: format_task(task), status: :ok
    else
      render json: { errors: task.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    task = Task.find_by(task_list_id: params[:listId], id: params[:taskId])

    unless task
      render json: { error: 'Task not found' }, status: :not_found
      return
    end

    task.destroy
    head :no_content
  end

  def format_task(task)
    {
      idTask: task.id,
      taskDescription: task.task_description,
      isTaskDone: task.is_task_done,
      createdAt: task.created_at,
      updatedAt: task.updated_at
    }
  end

  def task_params
    params.permit(:task_description, :is_task_done)
  end
end
