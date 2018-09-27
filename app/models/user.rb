class User < ApplicationRecord

	ROLE_SUPER_ADMIN = 1
	ROLE_ADMIN       = 2

	validates :name, presence: true

	EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

	validates :email, presence: true,
					  format: { with: EMAIL_REGEX },
					  uniqueness: true

	validates :biography, length: { maximum: 200 }
					  
	has_secure_password

 	has_many :active_relationships, class_name:  "Relationship",
                                  	foreign_key: "follower_id",
                                  	dependent: :destroy
	has_many :passive_relationships, class_name:  "Relationship",
	                                 foreign_key: "followed_id",
	                                 dependent:   :destroy
	has_many :following, through: :active_relationships,  source: :followed
	has_many :followers, through: :passive_relationships, source: :follower
	has_many :lessons

	has_many :categories, through: :lessons, source: :category
	has_many :answers, through: :lessons
	has_many :words, through: :answers

	mount_uploader :image, ImageUploader

	# ユーザーをフォローする
	def follow(other_user)
	  following << other_user
	end

	# ユーザーをフォロー解除する
	def unfollow(other_user)
	  active_relationships.find_by(followed_id: other_user.id).destroy
	end

	# 現在のユーザーがフォローしてたらtrueを返す
	def following?(other_user)
	  following.include?(other_user)
	end


	def followers
		Relationship.where(followed_id: id)
	end

	def followed
		Relationship.where(follower_id: id)
	end

	def relationship(other_user)
		Relationship.find_by(
			follower_id: id,
			followed_id: other_user.id)
	end

	def super_admin?
		authority == User::ROLE_SUPER_ADMIN
	end

	def admin?
		authority == User::ROLE_ADMIN
	end
	
end
