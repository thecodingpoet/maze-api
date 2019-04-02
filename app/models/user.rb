class User < ApplicationRecord
  has_secure_password
  has_many :interests
  accepts_nested_attributes_for :interests

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /@/ },
                    case_sensitive: false
  validates :avatar, presence: true 
  validates :username, presence: true
  validates :birth_year, presence: true

  before_save :downcase_email

  def downcase_email
    self.email = email.delete(' ').downcase
  end
end
