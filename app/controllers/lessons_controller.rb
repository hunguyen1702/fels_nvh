class LessonsController < ApplicationController
  before_action :logged_in_user
  before_action :load_lesson, only: %i(show update destroy)
  before_action :correct_user, except: %i(index create)

  def index
    @lessons = current_user.lessons.page params[:page]
  end

  def show; end

  def create
    @lesson = Lesson.new lesson_params

    if @lesson.save
      flash[:success] = t "lesson.create.success"
      redirect_to @lesson
    else
      flash[:danger] = t "lesson.create.failed"
      redirect_to lessons_path
    end
  end

  def update
    @lesson.update_attributes lesson_params
    if @lesson.valid?
      @lesson.save
      flash[:success] = t "lesson.update.success"
    else
      flash[:danger] = t "lesson.update.failed"
    end
    redirect_to lessons_path
  end

  def destroy
    if @lesson.destroy
      @message_type = Settings.message.success
      @message = t "lesson.destroy.success"
    else
      @message_type = Settings.message.danger
      @message = t "lesson.destroy.failed"
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def lesson_params
    params.require(:lesson).permit :category_id, :user_id, :status,
      results_attributes: [:id, :answer_id]
  end

  def load_lesson
    @lesson = Lesson.find_by id: params[:id]

    return if @lesson
    flash[:danger] = t "lesson.not_found"
    redirect_to lessons_path
  end

  def correct_user
    user = User.find_by id: @lesson.user_id

    redirect_to lessons_path unless user.is_user? current_user
  end
end
