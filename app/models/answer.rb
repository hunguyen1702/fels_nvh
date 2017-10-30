class Answer < ApplicationRecord
  belongs_to :word
  has_many :results, dependent: :destroy

  scope :correct_answers, (lambda do |user_answers|
    where("id in (?)", user_answers).where is_correct: true
  end)
end
