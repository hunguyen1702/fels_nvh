class Admin::StaticPagesController < AdminController
  before_action :logged_in_user, :verify_admin!

  def home
    @total_users = User.all.size
    @total_categories = Category.all.size
    @total_words = Word.all.size
  end
end
