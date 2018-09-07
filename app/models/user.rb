class User < ApplicationRecord
	validates :name, presence: true

	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email, presence: true,
					  format: { with: EMAIL_REGEX },
					  uniqueness: true
					  
	has_secure_password
end