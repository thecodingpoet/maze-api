FactoryBot.define do
  factory :comment do
    user { nil }
    writing { nil }
    content { "MyText" }
  end
end
