class Question < ApplicationRecord
  has_many :answers, -> { order(best: :desc, created_at: :asc) }, dependent: :destroy
  belongs_to :user

  validates :title, :body, presence: true
end
