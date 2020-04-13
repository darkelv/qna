class Question < ApplicationRecord
  has_many :answers, -> { order(best: :desc, created_at: :asc) }, dependent: :destroy
  belongs_to :user
  has_one_attached :file

  has_many_attached :files

  validates :title, :body, presence: true
end
