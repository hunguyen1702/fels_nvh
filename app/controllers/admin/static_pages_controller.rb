class Admin::StaticPagesController < AdminController
  def home
    @total_users = User.count
    @total_categories = Category.count
    @total_words = Word.count
  end
end
