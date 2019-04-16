class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :writing

  validates :content, presence: true 
end
