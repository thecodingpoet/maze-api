FactoryBot.define do
  factory :strength do
    name { Faker::Name.name }
    selected { Faker::Boolean.boolean }
  end
end
