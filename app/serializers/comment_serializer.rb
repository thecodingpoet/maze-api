class CommentSerializer
  include FastJsonapi::ObjectSerializer
  attributes :content, :approved, :created_at

  attribute :read, if: Proc.new { |record, params|
    params && params[:show_read] == true
  }

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
