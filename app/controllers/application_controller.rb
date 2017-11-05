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

  def create_activity
    if @description && @action_type
      Activity.create! user: current_user, description: @description,
        action_type: @action_type
    end
  end
end
