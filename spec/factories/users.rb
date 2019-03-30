FactoryBot.define do
  factory :user do
    avatar { Faker::Avatar.image }
    username { Faker::Internet.username }
    gender { Faker::Gender.binary_type }
    email { Faker::Internet.email }
    password { "Password" }
    birth_year { Faker::Number.number(4) }
  end
end
