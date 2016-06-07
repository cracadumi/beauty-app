class UserMailer < ApplicationMailer
  def welcome_beautician(user_id)
    @user = User.find_by(id: user_id)
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'Welcome beautician')
  end

  def welcome_user(user_id)
    @user = User.find_by(id: user_id)
    mail(to: @user.email,
         content_type: 'text/html',
         subject: 'Welcome user')
  end
end
