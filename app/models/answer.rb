class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question }, if: :best

  def make_best
    best_answer = question.answers.find_by(best: true)

    Answer.transaction do
      best_answer&.update!(best: false)
      update!(best: true)
    end
  end
end
