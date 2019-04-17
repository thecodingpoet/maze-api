class WritingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :entry

  belongs_to :user
  has_many :comments
end
