class Category < ApplicationRecord
  has_many :words, dependent: :destroy
  has_many :lessons, dependent: :destroy

  paginates_per Settings.category.page_size
  max_paginates_per Settings.category.page_size

  validates :name, presence: true, uniqueness: {case_sensitive: false}
  validates :description, presence: true

  scope :desc_time, ->{order updated_at: :desc}
  scope :category_info, ->{select :id, :name, :description, :updated_at}
  scope :not_empty_categories, (lambda do
    joins(:words).group(:category_id)
      .having "count(category_id) >= ?", Settings.category.min_words
  end)
end
