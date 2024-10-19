class Tag < ApplicationRecord
  belongs_to :user
  has_many :task_lists, dependent: :nullify


  validates :tag_name, presence: true
end
