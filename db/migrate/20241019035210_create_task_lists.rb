class CreateTaskLists < ActiveRecord::Migration[7.2]
  def change
    create_table :task_lists do |t|
      t.string :title
      t.string :attachment
      t.decimal :percentage
      t.references :user, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
