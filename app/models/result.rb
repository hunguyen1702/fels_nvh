class Result < ApplicationRecord
  belongs_to :lesson
  belongs_to :word
  belongs_to :answer, optional: true
  delegate :is_correct, to: :answer, allow_nil: true

  scope :lesson_answers, ->lessons do
    select(:answer_id).where "lesson_id in (?)", lessons
  end
end
