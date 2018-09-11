class Admin::CategoriesController < ApplicationController
	before_action :administrator

	def new
		@category = Category.new
	end

	def create
		@category = Category.new(category_params)

		if @category.save
			redirect_to admin_categories_path
		else
			render "new"
		end
	end

	def index
		@categories = Category.paginate(page: params[:page], per_page: 6)
	end

	def show
		@category = Category.find(params[:id])
	end

	def edit
		@category = Category.find(params[:id])
	end

	def update
		@category = Category.find(params[:id])
		if @category.update(category_params)
		   redirect_to admin_categories_path
		else
			render "edit"
		end
	end

	def destroy
	@category = Category.find(params[:id])
	@category.destroy
	redirect_to admin_categories_path
	end

	private

	def category_params
    	params.require(:category).permit(:title, :description, :importance)
 	end
 
    def administrator
		unless current_user.admin?
			redirect_to root_url
		end
    end

end
