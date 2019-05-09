class UserMailer < ApplicationMailer
  default :from => "admin@i-lu.com"

  def signup_confirmation(user)
    @user = user
    mail(:to => "#{user.email}", :subject => "Confirm your account on I-LU")
  end

  def reset_password(user)
    @user = user
    mail(:to => "#{user.email}", :subject => "Reset Password")
  end
end
