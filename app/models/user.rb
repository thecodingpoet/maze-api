class User < ApplicationRecord
  has_secure_password
  has_many :strengths, dependent: :destroy
  has_many :concerns, dependent: :destroy
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
  validates :username, presence: true,
                       uniqueness: true

  before_save :downcase_email
  before_create :generate_confirmation_instructions

  def downcase_email
    self.email = email.delete(' ').downcase
  end

  def generate_confirmation_instructions
    self.confirmation_token = SecureRandom.hex(10)
    self.confirmation_sent_at = Time.now.utc
  end

  def confirmation_token_valid?
    (self.confirmation_sent_at + 30.days) > Time.now.utc
  end
  
  def mark_as_confirmed!
    self.confirmation_token = nil
    self.confirmed_at = Time.now.utc
    save
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
