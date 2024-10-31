class Task < ApplicationRecord
  before_save :set_default_is_task_done

  belongs_to :task_list

  attribute :is_task_done, :boolean, default: false

  validates :task_description, presence: true, length: { minimum: 3, message: "must be at least 3 characters long" }
  validates :is_task_done, inclusion: { in: [ true, false ] }

  def set_default_is_task_done
    self.is_task_done = false if is_task_done.nil?
  end
end
