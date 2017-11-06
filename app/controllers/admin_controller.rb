class AdminController < ApplicationController
  layout "admin/layouts/admin"

  def verify_admin!
    return if current_user.admin?

    flash[:danger] = t "user.require_admin"
    redirect_to root_path
  end
end
