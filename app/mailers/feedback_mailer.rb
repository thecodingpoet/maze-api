class FeedbackMailer < ApplicationMailer
  def new_feedback_notification(feedback)
    @feedback = feedback
    mail(:to => "admin@Maze.com", :subject => "Maze Feedback Received")
  end
end
