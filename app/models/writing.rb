class Writing < ApplicationRecord
  belongs_to :user
  has_many :comments

  validates :title, presence: true, :uniqueness => {:scope => [:user, :title]}
  validates :entry, presence: true
end
