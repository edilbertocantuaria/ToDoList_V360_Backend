class Task < ApplicationRecord
  before_save :set_default_is_task_done

  belongs_to :task_list

  attribute :is_task_done, :boolean, default: false

  validates :task_description, presence: true, length: {minimum:3}
  validates :is_task_done, inclusion:{in: [true, false]}

  validate :task_description_must_be_string

  def set_default_is_task_done
    self.is_task_done = false if is_task_done.nil?
  end

  def task_description_must_be_string
    unless task_description.is_a?(String)
      errors.add(:name, 'Task description must be a string.')
    end
  end
  
end
