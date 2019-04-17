class Writing < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, presence: true
  validates :entry, presence: true
end
