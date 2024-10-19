class CreateTasks < ActiveRecord::Migration[7.2]
  def change
    create_table :tasks do |t|
      t.text :task_description
      t.boolean :is_task_done
      t.references :task_list, null: false, foreign_key: true

      t.timestamps
    end
  end
end
