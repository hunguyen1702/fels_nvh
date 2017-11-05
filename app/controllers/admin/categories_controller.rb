class Admin::CategoriesController < AdminController
  before_action :load_category, only: [:update, :destroy]

  def index
    @categories = Category.category_info.desc_time.page params[:page]
  end

  def new
    @category = Category.new
    respond_to_category
  end

  def create
    @category = Category.new category_params

    if @category.save
      flash[:success] = t "admin.category.new.create_success"
    else
      flash[:danger] = t "admin.category.new.create_failed"
    end
    redirect_to admin_categories_path
  end

  def update
    if @category.update_attributes category_params
      respond_message t("admin.category.edit.update_success"), :success.to_s
    else
      respond_message t("admin.category.edit.update_failed"), :danger.to_s
    end
    @category.reload
    respond_to_category
  end

  def destroy
    if @category.words.size > 0
      flash[:danger] = t "admin.category.destroy.not_empty_cat"
    else
      if @category.destroy
        flash[:success] = t "admin.category.destroy.delete_success"
      else
        flash[:danger] = t "admin.category.destroy.delete_failed"
      end
    end
    redirect_to admin_categories_path
  end

  private

  def category_params
    params.require(:category).permit :name, :description
  end

  def load_category
    @category = Category.find_by id: params[:id]

    return if @category
    flash[:danger] = t "admin.category.not_found"
    redirect_to admin_categories_path
  end

  def respond_to_category
    respond_to do |format|
      format.js
    end
  end

  def respond_message message, message_type
    @message = message
    @message_type = message_type
  end
end
