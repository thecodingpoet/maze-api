class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :writing, :counter_cache => true

  validates :content, presence: true 

  scope :approved, -> { where(approved: true) }
end
