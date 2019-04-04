FactoryBot.define do
  factory :concern do
    name { Faker::Name.name }
    selected { Faker::Boolean.boolean }
  end
end
