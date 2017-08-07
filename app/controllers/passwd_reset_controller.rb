class PasswdResetController < ApplicationController

  def main

  end

  def create
    @user = User.find_by(id: params[:id])
    if @user
      @user.create_reset_digest
      @user.send_passwd_reset_email
      flash[:info] = :reset_passwd_email_sent
      redirect_to root_url
    else
      flash[:danger] = :user_not_found
      render 'main'
    end
  end

  def receive

  end

  def reset
  end

  private
    def get_user_from_mail
      @user = User.find_by(mail: params[:mail])
    end

    def require_user
      redirect_to root_url unless @user
    end
end
