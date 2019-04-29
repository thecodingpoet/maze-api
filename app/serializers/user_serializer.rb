class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :username, :avatar, :birth_year, :gender, :education, :created_at
  has_many :strengths
  has_many :concerns
end
