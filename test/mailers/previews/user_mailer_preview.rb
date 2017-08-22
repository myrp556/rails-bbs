# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/passwd_reset
  def passwd_reset
    user = User.first
    user.reset_token = User.new_token
    UserMailer.passwd_reset(user)
  end

end