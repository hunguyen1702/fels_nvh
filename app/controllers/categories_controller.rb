class CategoriesController < ApplicationController
  before_action :logged_in_user, only: :index

  def index
    @categories = Category.category_info.not_empty_categories
      .desc_time.page params[:page]
  end

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "inform_login"
    redirect_to login_path
  end
end
