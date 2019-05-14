class WritingMailer < ApplicationMailer
  def thread_closure_notification(writing, user)
    @writing = writing 
    @user = user 
    mail(:to => "#{@user.email}", :subject => "I-LU")
  end
end
