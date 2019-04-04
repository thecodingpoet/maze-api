FactoryBot.define do
  factory :user do
    avatar { Faker::Avatar.image }
    username { Faker::Internet.username }
    gender { Faker::Gender.binary_type }
    email { Faker::Internet.email }
    password { "Password" }
    birth_year { Faker::Number.number(4) }

    factory :user_with_interests do
      after(:create) do |user|
        create_list(:strength, 3, user: user)
        create_list(:concern, 3, user: user)
      end
    end
  end
end
