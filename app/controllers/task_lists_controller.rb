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
    @task_list = @current_user.task_lists.includes(:tasks).find(params[:id])
    render json: format_task_list(@task_list), status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Task list not found' }, status: :not_found
  end

  def create
    ActiveRecord::Base.transaction do
      @task_list = @current_user.task_lists.new(task_list_params)
  
      if @task_list.save
        render json: format_task_list(@task_list), status: :created
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
      render json: format_task_list(@task_list), status: :ok
    else
      render json: { errors: @task_list.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @task_list = @current_user.task_lists.find(params[:id])

    if @task_list
      @task_list.destroy
      head :no_content
    else
      render json: { error: 'Task list not found' }, status: :not_found
    end
  end

  def format_task_list(task_list)
    {
      idTaskList: task_list.id,
      titleTask: task_list.title,
      idTag: task_list.tag_id,
      percentage: task_list.percentage,
      attachment: task_list.attachment,
      createdAt: task_list.created_at,
      updatedAt: task_list.updated_at,
      tasks: task_list.tasks.map { |task| format_task(task) }
    }
  end

  def task_list_params
    params.require(:task_list).permit(:title, :attachment, :tag_id, tasks_attributes: [:task_description])
  end  

  def format_errors(errors)
    errors.full_messages
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
end
