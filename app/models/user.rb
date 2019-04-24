class User < ApplicationRecord
  has_secure_password
  has_many :strengths
  has_many :concerns
  has_many :writings, dependent: :destroy
 
  has_many :active_friendships, class_name: "Friendship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_friendships, class_name: "Friendship", foreign_key: "followed_id", dependent: :destroy

  has_many :following, through: :active_friendships, source: :followed
  has_many :followers, through: :passive_friendships, source: :follower

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

  def follow(user)
    active_friendships.create(followed_id: user.id)
  end

  def unfollow(user)
    active_friendships.find_by(followed_id: user.id).destroy
  end

  def following?(user)
    following.include?(user)
  end
end
