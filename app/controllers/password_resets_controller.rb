class PasswordResetsController < ApplicationController
  before_action :load_user, :valid_user, :check_expiration,
    only: [:edit, :update]

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = t "mailer.password_reset.email_sent"
      redirect_to root_path
    else
      flash.now[:danger] = t "mailer.password_reset.email_not_found"
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      flash.now[:danger] = t "password_reset.edit_view.empty"
      render :edit
    elsif @user.update_attributes user_params
      log_in @user
      @user.update_attributes reset_digest: nil
      flash[:success] = t "password_reset.edit_view.success"
      redirect_to root_path
    else
      flash.now[:danger] = t "password_reset.edit_view.invalid"
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def load_user
    @user = User.find_by email: params[:email]

    return if @user
    flash[:danger] = t "user.not_exist"
    redirect_to root_path
  end

  def valid_user
    return if @user && @user.is_activated? &&
      @user.authenticated?(:reset, params[:id])

    flash[:danger] = t "user.invalid_info"
    redirect_to root_url
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = t "password_reset.edit_view.expired"
    redirect_to new_password_reset_url
  end
end
