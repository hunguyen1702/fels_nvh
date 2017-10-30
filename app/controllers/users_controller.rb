class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      flash[:info] = t "user.create_success"
      redirect_to root_path
    else
      flash[:danger] = t "user.create_failed"
      redirect_to signup_path
    end
  end

  private

  def user_params
    params.require(:user).permit :avatar, :name, :email,
      :password, :password_confirmation
  end
end
