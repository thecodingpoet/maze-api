class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :content, :read, :approved, :created_at

  attributes :user do |comment|
    {
      id: comment.user.id,
      username: comment.user.username,	
      avatar: comment.user.avatar,	
      created_at: comment.user.created_at
    }
  end

  belongs_to :writing
end
