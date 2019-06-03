class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :username, :avatar, :birth_year, :gender, :education, :terms_and_condition, :created_at
  has_many :strengths
  has_many :concerns
end
