class Writing < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy

  validates :title, presence: true 
  validates :entry, presence: true

  enum status: [:draft, :shared, :archived]

  default_scope { order(created_at: :desc) }
  
  scope :without_user_writings, -> (user) { where.not(:user_id => user.id) }
  scope :with_user_supports, -> (user) { joins(:comments).where(:comments => {user_id: user.id}) }
  scope :without_declined_support, -> { joins(:comments).merge(Comment.not_declined) }

  def get_thread_participants
    comments.approved.map { |comment| comment.user }.uniq
  end
end
