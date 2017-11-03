class Word < ApplicationRecord
  belongs_to :category
  has_many :examples, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy

  paginates_per Settings.word.page_size
  max_paginates_per Settings.word.page_size
end
