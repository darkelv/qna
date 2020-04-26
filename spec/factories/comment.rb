FactoryBot.define do
  factory :comment do
    body { 'MyComment' }
    user
    commentable { nil }

    trait :question do
      commentable { create(:question) }
    end

    trait :answer do
      commentable { create(:answer) }
    end

    trait :invalid do
      body { nil }
    end
  end
end
