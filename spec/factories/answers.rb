FactoryBot.define do
  factory :answer do
    body { "MyAnswerText" }
    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      after :create do |answer|
        file_path1 = Rails.root.join('app', 'assets', 'images', 'all_in_level.jpg')
        file_path2 = Rails.root.join('app', 'assets', 'images', 'passed_on_first_try.jpg')
        file1 = fixture_file_upload(file_path1, 'image/jpeg')
        file2 = fixture_file_upload(file_path2, 'image/jpeg')
        answer.files.attach(file1, file2)
      end
    end
  end
end
