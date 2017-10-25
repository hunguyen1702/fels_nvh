class Word < ApplicationRecord
  belongs_to :category
  has_many :examples, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :results, dependent: :destroy
end
