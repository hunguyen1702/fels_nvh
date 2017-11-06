class Admin::StaticPagesController < AdminController
  def home
    @total_users = User.length
    @total_categories = Category.length
    @total_words = Word.length
  end
end
