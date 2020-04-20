FactoryBot.define do
  factory :vote do
    user
    association :votable, factory: :question
  end
end
