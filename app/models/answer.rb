class Answer < ApplicationRecord
  include Linkable
  include Votable
  belongs_to :question, touch: true
  belongs_to :user

  validates :body, presence: true
  validates :best, uniqueness: { scope: :question }, if: :best

  has_many :comments, as: :commentable, dependent: :destroy

  has_many_attached :files

  after_create :send_answer_notify

  def make_best
    best_answer = question.answers.find_by(best: true)

    Answer.transaction do
      best_answer&.update!(best: false)
      update!(best: true)
      question.award&.update!(user: user)
    end
  end

  private

  def send_answer_notify
    NotificationJob.perform_later(self)
  end
end
