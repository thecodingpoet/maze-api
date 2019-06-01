class FeedbackSerializer
  include FastJsonapi::ObjectSerializer
  attributes :message
  
  belongs_to :user
end
