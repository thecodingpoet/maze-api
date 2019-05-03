class Writing < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, presence: true 
  validates :entry, presence: true

  enum status: [:draft, :shared, :archived]

  scope :without_declined_comments, -> { 
    where.not(:comments => { :approved => false }) 
  }
end
