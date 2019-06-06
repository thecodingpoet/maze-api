class WritingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :entry, :status, :created_at, :comments_count

  belongs_to :user
  has_many :comments
end
