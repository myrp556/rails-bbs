class AccountActivationsController < ApplicationController
  def edit
    user = User.find_by(mail: params[:mail])
    if user and !user.activated? and user.authenticated?(:activation, params[:token])
      user.activate
      log_in user
      flash[:succes] = t :account_activated
      redirect_to user_detail_url(id: user.id)
    else
      flash[:danger] = t :invalid_activation_link
      redirect_to root_url
    end
  end
end
