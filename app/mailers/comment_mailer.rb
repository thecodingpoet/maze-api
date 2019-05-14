class CommentMailer < ApplicationMailer
  def accepted_comment_notification(comment)
    @comment = comment
    mail(:to => "#{@comment.user.email}", :subject => "I-LU")
  end
  
  def declined_comment_notification(user)
    @comment = comment
    mail(:to => "#{@comment.user.email}", :subject => "I-LU")
  end 
end
