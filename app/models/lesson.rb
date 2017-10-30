class Lesson < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :results, dependent: :destroy

  enum status: {fresh: 0, in_progress: 1, finished: 2}

  scope :user_lesson, ->user_id{select(:id).where user_id: user_id}
end
