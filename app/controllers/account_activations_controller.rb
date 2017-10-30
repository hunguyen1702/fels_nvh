class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by email: params[:email]

    if user && !user.is_activated? &&
      user.authenticated?(:activation, params[:id])
      user.activate
      log_in user
      flash[:success] = t "user.activate_success"
    else
      flash[:danger] = t "user.activate_failed"
    end
    redirect_to root_path
  end
end
