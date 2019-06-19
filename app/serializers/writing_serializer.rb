class WritingSerializer
  include FastJsonapi::ObjectSerializer
  attributes :title, :entry, :status, :created_at

  attribute :comments_count do |writing|
    writing.comments.not_declined.count
  end

  attribute :pending_approval_count do |writing|
    writing.comments.pending_approval.count
  end

  belongs_to :user
  has_many :comments
end
