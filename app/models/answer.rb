class Answer < ApplicationRecord
  belongs_to :word
  has_many :results, dependent: :destroy

  validates :content, presence: true
  validate :valid_answer?

  scope :correct_answers, (lambda do |user_answers|
    where("id in (?)", user_answers).where is_correct: true
  end)

  private

  def valid_answer?
    errors.add :is_correct,
      I18n.t("admin.answer.create.is_correct_nil") if is_correct.nil?
  end
end
