class ChangeTagIdNullInTaskLists < ActiveRecord::Migration[7.2]
  def change
    change_column_null :task_lists, :tag_id, true
  end
end
