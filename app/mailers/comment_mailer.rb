class CommentMailer < ApplicationMailer
  def accepted_comment_notification(comment)
    @comment = comment
    mail(:to => "#{@comment.user.email}", :subject => "I-LU")
  end
  
  def declined_comment_notification(comment)
    @comment = comment
    mail(:to => "#{@comment.user.email}", :subject => "I-LU")
  end 

  def new_comment_notification(writing, user)
    @writing = writing 
    @user = user 
    mail(:to => "#{@user.email}", :subject => "I-LU")
  end

  def new_support_notification(writing)
    @writing = writing 
    mail(:to => "#{@writing.user.email}", :subject => "I-LU")
  end
end
