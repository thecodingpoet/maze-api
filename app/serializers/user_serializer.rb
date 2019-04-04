class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :username, :avatar, :birth_year, :gender
  has_many :strengths
  has_many :concerns
end
