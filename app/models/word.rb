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

  scope :by_category, (lambda do |category_id|
    where category_id: category_id if category_id.present?
  end)
  scope :keyword_search, (lambda do |keyword|
    where "content like (?)", "%#{keyword}%" if keyword.present?
  end)
  scope :by_status, (lambda do |status, ids|
    case status.to_i
    when Settings.word.learned
      where "id in (?)", ids
    when Settings.word.unlearned
      where "id not in (?)", ids
    end
  end)
  scope :random_generate, ->num{order("RAND()").limit num}

  paginates_per Settings.word.page_size
  max_paginates_per Settings.word.page_size

  private

  def contain_enough_answer?
    errors.add :answers, I18n.t("admin.word.create.not_enough_answers") if
      answers.size < Settings.word.max_answers
  end

  def have_correct_answer?
    correct_answer_num = answers.select{|answer| answer.is_correct == true}
      .length
    unless correct_answer_num == Settings.word.correct_answer
      errors.add :answers, I18n.t("admin.word.create.have_correct_answer")
    end
  end
end
