class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :username, :avatar, :birth_year, :gender, :education
  has_many :strengths
  has_many :concerns
end
