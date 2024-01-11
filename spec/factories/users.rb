FactoryBot.define do
  sequence :email do |n|
    "user#{n}@test.com"
  end

  factory :user do
    email
    password { 'qweqwe' }
    password_confirmation { 'qweqwe' }
  end
end
