class User < ApplicationRecord
  has_secure_password
  has_many :strengths
  has_many :concerns
  accepts_nested_attributes_for :strengths, :concerns

  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /@/ },
                    case_sensitive: false
  validates :avatar, presence: true 
  validates :birth_year, presence: true
  validates :education, presence: true
  validates :username, presence: true,
                       uniqueness: true

  before_save :downcase_email

  def downcase_email
    self.email = email.delete(' ').downcase
  end
end
