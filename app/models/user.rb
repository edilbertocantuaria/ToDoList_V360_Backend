class User < ApplicationRecord
    has_many :task_lists
    has_many :tags
    
    has_secure_password
    validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
    validates :name, presence: true, format: { with: /\A[[:alpha:]\s]+\z/, message: 'Only alphabetic characters.' }
    validates :password, presence: true, length: { minimum: 6 }

    validate  :user_picture_is_valid_url
    validate  :name_must_be_string
    validate  :password_must_be_string

    def user_picture_is_valid_url
      return if user_picture.blank? 
  
      unless user_picture =~ /\A(http|https):\/\/[^\s]+/ 
        errors.add(:user_picture, 'User picture must be an URL valid.')
      end
    end

    def name_must_be_string
      unless name.is_a?(String)
        errors.add(:name, 'Name ust be a string.')
      end
    end

    def password_must_be_string
      unless password.is_a?(String)
        errors.add(:password, 'Password must be a string.')
      end
    end


end