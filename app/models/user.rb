class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true,
                    uniqueness: true,
                    format: { with: /@/ },
                    case_sensitive: false

  before_save :downcase_email

  def downcase_email
    self.email = email.delete(' ').downcase
  end
end
