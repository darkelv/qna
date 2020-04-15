class Question < ApplicationRecord
  has_many :answers, -> { order(best: :desc, created_at: :asc) }, dependent: :destroy
  belongs_to :user
  has_many :links, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  validates :title, :body, presence: true
end
