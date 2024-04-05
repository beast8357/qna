FactoryBot.define do
  factory :comment do
    commentable { nil }
    association :author, factory: :user
    body { 'comment text' }
  end
end
