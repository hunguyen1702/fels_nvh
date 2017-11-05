class Lesson < ApplicationRecord
  before_create :build_questions
  before_update :update_status

  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy
  has_many :words, through: :results
  has_many :answers, through: :results
  accepts_nested_attributes_for :results

  enum status: {fresh: 0, in_progress: 1, finished: 2}

  validates :category, presence: true
  validates :user, presence: true
  validates :status, presence: true

  paginates_per Settings.lesson.page_size
  max_paginates_per Settings.lesson.page_size

  def score
    if self.finished?
      "#{self.answers.correct_answers.size}/#{self.answers.size}"
    else
      "-"
    end
  end

  def action_name
    case status
    when :fresh.to_s
      I18n.t "lesson.index_view.start"
    when :in_progress.to_s
      I18n.t "lesson.index_view.continue"
    when :finished.to_s
      I18n.t "lesson.index_view.view"
    end
  end

  private

  def build_questions
    words = self.category.words.random_generate Settings.lesson.answers_num
    words.each{|word| self.results.build word_id: word.id}
  end

  def update_status
    answereds = results.select{|result| result.answer_id.present?}
    if answereds.size < words.size
      self.status = :in_progress
    else
      self.status = :finished
    end
  end
end
