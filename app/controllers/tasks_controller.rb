class TasksController < ApplicationController
  include AuthorizeRequest

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
  
      if params[:tasks].nil? || !params[:tasks].is_a?(Array)
        render json: { error: 'Invalid task parameters' }, status: :unprocessable_entity
        return
      end
  
      tasks_params = params[:tasks].map do |task|
        task.permit(:task_description, :is_task_done).to_h
      end
  
      tasks_params.each do |task_params|
        task_params[:is_task_done] = false if task_params[:is_task_done].nil?
        task_list.tasks.build(task_params)
      end
  
      if task_list.save
        render json: task_list.tasks.map { |task| format_task(task) }, status: :created
      else
        render json: { errors: task_list.errors.full_messages }, status: :unprocessable_entity
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
