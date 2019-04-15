class Writing < ApplicationRecord
  belongs_to :user

  validates :title, presence: true 
  validates :entry, presence: true
end
