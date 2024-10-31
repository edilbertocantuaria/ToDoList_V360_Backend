class User < ApplicationRecord
  has_many :task_lists, dependent: :destroy
  has_many :tags, dependent: :destroy

  has_secure_password
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, format: { with: /\A[[:alpha:]\s]+\z/, message: "Only alphabetic characters." }
  validates :password, presence: true, length: { minimum: 6 }, confirmation: true
  validates :password_confirmation, presence: true

  validate  :user_picture_is_valid_url

  def user_picture_is_valid_url
    return if user_picture.blank?

    unless user_picture =~ /\A(http|https):\/\/[^\s]+/
      errors.add(:user_picture, "User picture must be an URL valid.")
    end
  end
end
