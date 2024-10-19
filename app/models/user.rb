class User < ApplicationRecord
    has_many :task_lists
    has_many :tags
    
    has_secure_password
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :name, presence: true
    validates :password, presence: true, length: { minimum: 6 }
  end