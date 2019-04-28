class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :content, :created_at, :approved
  belongs_to :user
  belongs_to :writing
end
