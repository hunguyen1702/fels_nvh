class ActivitiesController < ApplicationController
  before_action :logged_in_user, :load_activity, :correct_user

  def destroy
    if @activity.destroy
      respond_to do |format|
        format.js
      end
    else
      flash[:danger] = t "activity.destroy.error"
      redirect_to current_user
    end
  end

  private

  def load_activity
    @activity = Activity.find_by id: params[:id]

    return if @activity
    flash[:danger] = t "activity.destroy.not_found"
    redirect_to current_user
  end

  def correct_user
    user = User.find_by id: @activity.user.id

    return if user.is_user? current_user
    flash[:danger] = t "activity.destroy.not_permit"
    redirect_to current_user
  end
end
