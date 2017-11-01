class SessionsController < ApplicationController
  def new; end

  def create
    user = User.find_by email: params[:session][:email].downcase

    if user && user.authenticate(params[:session][:password])
      if user.is_activated?
        log_in user
        params[:session][:remember_me].to_i == 1 ? remember(user) : forget(user)
        flash[:success] = t "session.new_view.login_success"
        redirect_back_or user
      else
        flash[:warning] = t "user.not_activate"
        redirect_to root_path
      end
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
