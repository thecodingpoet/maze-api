class WritingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :entry, :created_at

  belongs_to :user
  has_many :comments
end
