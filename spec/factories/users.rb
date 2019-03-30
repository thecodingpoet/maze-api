FactoryBot.define do
  factory :user do
    avatar { "MyString" }
    username { "TomHardy" }
    gender { "Male" }
    email { "user@example.com" }
    password { "Password" }
    birth_year { 1988 }
  end
end
