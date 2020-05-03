class QuestionSerializer < ActiveModel::Serializer
  attributes %w[id title body created_at updated_at]

  has_many :answers
  belongs_to :user
end
