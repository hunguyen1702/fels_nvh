class Result < ApplicationRecord
  belongs_to :lesson
  belongs_to :word
  belongs_to :answer

  scope :lesson_answers, ->lessons do
    select(:answer_id).where "lesson_id in (?)", lessons
  end
end
