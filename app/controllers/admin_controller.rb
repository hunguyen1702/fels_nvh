class AdminController < ApplicationController
  before_action :logged_in_user, :verify_admin!

  layout "admin/layouts/admin"

  def verify_admin!
    return if current_user.admin?

    flash[:danger] = t "user.require_admin"
    redirect_to root_path
  end
end
