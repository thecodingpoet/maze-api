class User < ApplicationRecord
  validates :email, presence: true,
                    format: { with: /@/ },
                    unique: true,
                    case_sensitive: false
end
