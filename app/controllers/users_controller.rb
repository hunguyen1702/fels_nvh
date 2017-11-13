class UsersController < ApplicationController
  before_action :load_user, except: %i(new create index)
  before_action :logged_in_user, only: %i(edit update index)
  before_action :correct_user, only: :update

  def index
    @users = User.users_info.all_except(current_user)
      .activated_user.page params[:page]
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params
    if @user.save
      @user.send_activation_email
      flash[:info] = t "user.create_success"
      redirect_to root_path
    else
      flash[:danger] = t "user.create_failed"
      redirect_to signup_path
    end
  end

  def show; end

  def edit; end

  def update
    if @user.update_attributes user_params
      flash[:success] = t "user.edit_view.update_success"
      redirect_to root_path
    else
      flash.now[:danger] = t "user.edit_view.update_failed"
      render :edit
    end
  end

  def following
    @title = t("user.following").capitalize
    @users = @user.following.page params[:page]
    render "show_follow"
  end

  def followers
    @title = t("user.follower").capitalize
    @users = @user.followers.page params[:page]
    render "show_follow"
  end

  private

  def load_user
    @user = User.find_by id: params[:id]

    return if @user && @user.is_activated?
    flash[:danger] = t "user.not_exist"
    redirect_to root_path
  end

  def correct_user
    redirect_to root_path unless @user.is_user? current_user
  end

  def user_params
    params.require(:user).permit :avatar, :name, :email,
      :password, :password_confirmation
  end
end
