class RelationshipsController < ApplicationController
  before_action :logged_in_user
  after_action :create_activity

  def create
    @user = User.find_by id: params[:followed_id]
    current_user.follow @user
    @description = t "relationship.create_activity",
      name: @user.name
    @action_type = :following
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end

  def destroy
    @user = Relationship.find_by(id: params[:id]).followed
    current_user.unfollow @user
    @description = t "relationship.destroy_activity",
      name: @user.name
    @action_type = :unfollow
    respond_to do |format|
      format.html{redirect_to @user}
      format.js
    end
  end
end
