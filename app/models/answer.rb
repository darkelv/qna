class Answer < ApplicationRecord
  include Linkable

  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question }, if: :best

  has_many_attached :files

  def make_best
    best_answer = question.answers.find_by(best: true)

    Answer.transaction do
      best_answer&.update!(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end
end
