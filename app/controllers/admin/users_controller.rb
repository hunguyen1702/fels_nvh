class Admin::UsersController < AdminController
  before_action :load_user, only: :destroy

  def index
    @users = User.all.page params[:page]
  end

  def destroy
    if @user.destroy
      flash[:success] = t "user.delete_success"
    else
      flash[:danger] = t "user.delete_failed"
    end
    redirect_to admin_users_path
  end

  private

  def load_user
    @user = User.find_by id: params[:id]

    return if @user && @user.is_activated?
    flash[:danger] = t "user.not_exist"
    redirect_to root_path
  end
end
