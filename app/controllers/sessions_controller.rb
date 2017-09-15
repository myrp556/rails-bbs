class SessionsController < ApplicationController
  def new
    redirect_to '/' if logged_in?
  end

  def create
    user=User.find_by(user_name: params[:user][:user_name])
    if user && user.authenticate(params[:user][:password])
      if user.activate?
        log_in user
        remember user
        redirect_to root_path
      else
        flash[:warning] = t :account_not_activated
        redirect_to root_url
      end
    else
      flash.now[:danger] = t :fault_login
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to '/'
  end

  private
  def user_params

  end
end
