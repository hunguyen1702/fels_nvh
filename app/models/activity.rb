class Activity < ApplicationRecord
  belongs_to :user
  validates :description, presence: true
  validates :action_type, presence: true

  enum action_type: {following: 0, unfollow: 1,
    create_lesson: 2, finish_lesson: 3}

  scope :of_user, ->user{where user_id: user.id}
  scope :desc, ->{order created_at: :desc}
  scope :feed, (lambda do |user_id, following_ids|
    where "user_id in (:following_ids) or user_id = :user_id",
      user_id: user_id, following_ids: following_ids
  end)
end
