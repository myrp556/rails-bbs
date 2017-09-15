class UserMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.passwd_reset.subject
  #
  def account_activation(user)
    @user = user
    mail to: user.mail, subject: "Account activation"
  end

  def passwd_reset(user)
    @user = user
    mail to: user.mail, subject: "Password reset"
  end
end
