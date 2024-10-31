class TaskList < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  has_many :tasks, dependent: :destroy

  validates :title, presence: true, length: { minimum: 3, message: "must be at least 3 characters long" }
  validates :attachment, format: { with: URI.regexp(%w[http https]), message: "Attachment must be a valid URL" }, allow_blank: true

  accepts_nested_attributes_for :tasks, reject_if: :all_blank

  validate :attachment_is_valid_url
  validate :tag_belongs_to_user

  def attachment_is_valid_url
    return if attachment.blank?

    unless attachment =~ /\A(http|https):\/\/[^\s]+/
      errors.add(:attachment, "Attachment must be a valid URL.")
    end
  end

  def tag_belongs_to_user
    if tag.present? && !user.tags.include?(tag)
      errors.add(:tag, "Tag must belong to the user.")
    end
  end

  def percentage
    return 0 if tasks.empty?
    done_tasks = tasks.where(is_task_done: true).count
    (done_tasks.to_f / tasks.count * 100).round(2)
  end
end
