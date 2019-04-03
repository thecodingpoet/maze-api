class UserSerializer
  include FastJsonapi::ObjectSerializer
  attributes :email, :username, :avatar, :birth_year, :gender
  has_many :interests
end
