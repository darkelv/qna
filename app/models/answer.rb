class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user

  validates :title, :body, presence: true
end
