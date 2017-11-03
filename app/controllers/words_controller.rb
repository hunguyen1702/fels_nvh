class WordsController < ApplicationController
  before_action :logged_in_user, only: %i(index show)
  before_action :load_word, only: :show

  def index
    @words = Word.all.page params[:page]
  end

  def show; end

  private

  def load_word
    @word = Word.find_by id: params[:id]

    return if @word
    flash[:danger] = t "word.not_found"
    redirect_to :index
  end
end
