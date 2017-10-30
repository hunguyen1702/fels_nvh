class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private

  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = t "user.edit_view.inform_login"
    redirect_to login_path
  end

  def verify_admin!
    return if current_user.admin?

    flash[:danger] = t "user.require_admin"
    redirect_to users_path
  end
end
