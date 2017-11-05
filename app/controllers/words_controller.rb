class WordsController < ApplicationController
  before_action :logged_in_user, only: %i(index show)
  before_action :load_word, only: :show

  def index
    @words = Word.all.keyword_search(params[:search])
      .by_category(params[:category])
      .by_status(params[:learned], current_user.learned_words)
      .page params[:page]
  end

  def show; end

  private

  def load_word
    @word = Word.find_by id: params[:id]

    return if @word
    flash[:danger] = t "word.not_found"
    redirect_to :index
  end

  def filter_by_status status
    learned_ids = current_user.learned_words
    case status.to_i
    when Settings.word.learned
      @words = @words.id_in_list learned_ids
    when Settings.word.unlearned
      @words = @words.id_not_in_list learned_ids
    end
  end
end
