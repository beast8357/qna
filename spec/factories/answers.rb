FactoryBot.define do
  factory :answer do
    association :question
    association :author, factory: :user
    body { "MyText" }

    trait :invalid do
      body { nil }
    end

    trait :with_files do
      files do
        [
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/file_1.txt"),
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/files/file_1.txt")
        ]
      end
    end
  end
end
