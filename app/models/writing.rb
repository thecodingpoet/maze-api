class Writing < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, presence: true 
  validates :entry, presence: true

  enum status: [:draft, :shared, :archived]
  
  scope :without_user_writings, -> (user) { where.not(:user_id => user.id) }
  scope :with_user_supports, -> (user) { joins(:comments).where(:comments => {user_id: user.id}).distinct }
  scope :without_declined_support, -> { joins(:comments).merge(Comment.not_declined) }
  scope :without_any_support, -> { left_outer_joins(:comments).where(:comments => { :user_id => nil }) }
  scope :without_user_supports, -> (user) {
    left_outer_joins(:comments).where.not(:comments => { :user_id => user.id }).or(without_any_support).distinct
  }

  def get_thread_participants
    comments.approved.map { |comment| comment.user }.uniq
  end
end
