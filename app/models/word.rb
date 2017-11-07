class Word < ApplicationRecord
  belongs_to :category
  has_many :examples, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy
  accepts_nested_attributes_for :answers, limit: Settings.word.max_answers,
    reject_if: :all_blank

  validates :category, presence: true
  validates :content, presence: true
  validate :contain_enough_answer?, :have_correct_answer?

  paginates_per Settings.word.page_size
  max_paginates_per Settings.word.page_size

  private

  def contain_enough_answer?
    errors.add :answers, I18n.t("admin.word.create.not_enough_answers") if
      answers.size < Settings.word.max_answers
  end

  def have_correct_answer?
    errors.add :answers, I18n.t("admin.word.create.have_correct_answer") unless
      answers.select {|answer| answer.is_correct == true}.length == 1
  end
end
