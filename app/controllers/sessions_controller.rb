class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me].to_i == 1 ? remember(user) : forget(user)
      flash[:info] = t "session.new_view.login_success"
      redirect_to root_path
    else
      flash[:danger] = t "session.new_view.login_failed"
      redirect_to login_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_path
  end
end
