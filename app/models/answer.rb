class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :links, dependent: :destroy, as: :linkable

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question }, if: :best

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank

  def make_best
    best_answer = question.answers.find_by(best: true)

    Answer.transaction do
      best_answer&.update!(best: false)
      update!(best: true)
    end
  end
end
