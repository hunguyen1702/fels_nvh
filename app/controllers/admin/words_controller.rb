class Admin::WordsController < AdminController
  before_action :load_word, only: %i(edit update destroy)

  def index
    @words = Word.all.keyword_search(params[:search])
      .by_category(params[:category]).page params[:page]
  end

  def new
    @word = Word.new
    if session[:word]
      @word.attributes = session[:word]
      session.delete :word
    else
      Settings.word.max_answers.times{@word.answers.build}
    end
  end

  def create
    @word = Word.new word_params
    process_saving t("admin.word.create.create_success"),
      new_admin_word_path
  end

  def edit
    if session[:word]
      @word.attributes = session[:word]
      session.delete :word
    end
  end

  def update
    @word.update_attributes word_params
    process_saving t("admin.word.edit.update_success"),
      edit_admin_word_path(@word)
  end

  def destroy
    if @word.destroy
      flash[:success] = t "admin.word.index.delete_success"
    else
      flash[:danger] = t "admin.word.index.delete_failed"
    end
    redirect_to admin_words_path
  end

  private

  def word_params
    params.require(:word).permit :content, :category_id,
      answers_attributes: [:id, :content, :is_correct]
  end

  def load_word
    @word = Word.find_by id: params[:id]

    return if @word
    flash[:danger] = t "admin.word.not_found"
    redirect_to admin_words_path
  end

  def process_saving success_msg, redirect_failed_path
    if @word.valid?
      @word.save
      flash[:success] = success_msg
      redirect_to admin_words_path
    else
      flash[:danger] = @word.errors.full_messages.first
      session[:word] = word_params
      redirect_to redirect_failed_path
    end
  end
end
