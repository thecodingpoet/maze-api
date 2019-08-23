class UserMailer < ApplicationMailer
  def signup_confirmation(user)
    @user = user
    mail(:to => "#{user.email}", :subject => "Confirm your account on Maze")
  end

  def reset_password(user)
    @user = user
    mail(:to => "#{user.email}", :subject => "Reset Password")
  end

  def welcome_message(user)
    @user = user
    mail(:to => "#{user.email}", :subject => "Welcome to Maze")
  end
end
