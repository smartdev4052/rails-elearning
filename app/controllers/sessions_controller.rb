class SessionsController < ApplicationController
	before_action :require_login, only: [:show, :index]

	def new
	end

	def create
		user = 	User.find_by(email: params[:session][:email])
 		if  user && user.authenticate(params[:session][:password])
			log_in user
			redirect_to dashboard_path
		else
		  	flash[:login] = "Invalid information."
		  	redirect_to root_url
		end
	end

	def show
		ids = current_user.following.ids
		ids << current_user.id

		@activities = Activity.where(user_id: ids).take(10)
	end

	def index
		@categories = current_user.categories
		@words = current_user.words
		if !params[:category].present? || params[:category].empty?
			@words = current_user.words.paginate(page: params[:page], per_page: 10)
		else
			@words = current_user.words.where(category_id: params[:category]).paginate(page: params[:page], per_page: 10)
		end
	end

	def destroy
		session.destroy
		flash[:notice] = "Logged out."
		redirect_to root_url
	end

	private

 	def require_login
		unless current_user
			flash[:login] ="You need to login to view this content. Please Login."
			redirect_to root_url
		end
	end
end
