class Writing < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, presence: true 
  validates :entry, presence: true

  enum status: [:draft, :shared, :archived]

  scope :without_user_writings, -> (user) {
    where.not(:user_id => user.id)
  }

  scope :without_user_supports, -> (user) {
    joins(:comments).where.not(:comments => { :user_id => user.id }).distinct
  }
end
