class Question < ApplicationRecord
  include Linkable

  has_many :answers, -> { order(best: :desc, created_at: :asc) }, dependent: :destroy
  belongs_to :user
  has_one :award, dependent: :destroy

  has_many_attached :files

  accepts_nested_attributes_for :award, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
