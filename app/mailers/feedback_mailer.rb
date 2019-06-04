class FeedbackMailer < ApplicationMailer
  def new_feedback_notification(feedback)
    @feedback = feedback
    mail(:to => "admin@i-lu.com", :subject => "I-LU Feedback Received")
  end
end
