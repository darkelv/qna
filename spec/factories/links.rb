FactoryBot.define do
  sequence :name do |n|
    "MyName#{n}"
  end

  factory :link do
    name
    url { Faker::Internet.url }
    linkable { nil }

    trait :invalid do
      url { 'wrong_url' }
    end

    trait :question do
      linkable { create(:question) }
    end

    trait :answer do
      linkable { create(:answer) }
    end

    trait :gist do
      url { 'https://gist.github.com/darkelv/6bd013e175248026492b1b68c4a86f48' }
    end

    trait :gist_empty do
      url { 'https://gist.github.com/darkelv/asdasdasdad' }
    end
  end
end
