class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :writing, :counter_cache => true

  validates :content, presence: true 

  scope :approved, -> { where(approved: true) }
  scope :declined, -> { where(approved: false) }
  scope :pending_approval, -> { where(approved: nil ) }
  scope :not_declined, -> { pending_approval.or approved }
end
