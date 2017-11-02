class Category < ApplicationRecord
  has_many :words, dependent: :destroy
  has_many :lessons, dependent: :destroy

  paginates_per Settings.category.page_size
  max_paginates_per Settings.category.page_size

  scope :category_info, ->{select :id, :name, :description}
  scope :not_empty_categories, -> do
    joins(:words).group(:category_id)
      .having "count(category_id) >= ?", Settings.category.min_words
  end
end
