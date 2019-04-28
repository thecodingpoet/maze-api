class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :content, :created_at, :approved

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
