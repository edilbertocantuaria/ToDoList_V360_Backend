class TaskList < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  has_many :tasks, dependent: :destroy

  validates :title, presence: true
  validates :attachment, format: { with: URI::regexp(%w[http https]), message: 'must be a valid URL' }, allow_blank: true
  
  validate :only_one_tag

  def only_one_tag
    if tag.present? && TaskList.where(user: user, tag: tag).count > 1
      errors.add(:tag, 'Only one tag is allowed per task list.')
    end
  end

end

