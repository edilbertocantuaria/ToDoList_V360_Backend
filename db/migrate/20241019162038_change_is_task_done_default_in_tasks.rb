class ChangeIsTaskDoneDefaultInTasks < ActiveRecord::Migration[7.2]
  def change
    change_column_default :tasks, :is_task_done, false
  end
end
