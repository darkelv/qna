FactoryBot.define do
  factory :award do
    title { 'MyTitle' }
    user { nil }
    question { nil }

    trait :invalid do
      title { nil }
    end

    trait :with_image do
      image { Rack::Test::UploadedFile.new('app/assets/images/all_in_level.jpg') }
    end
  end
end
