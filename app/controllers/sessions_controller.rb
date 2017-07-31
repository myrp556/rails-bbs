class SessionsController < ApplicationController
  def new

  end

  def create
    user=User.find_by(user_name: params[:user][:user_name])
    if user && user.authenticate(params[:user][:password])
      log_in user
      remember user
      redirect_to root_path
    else
      flash.now[:danger] = '不存在的用户或者错误的密码！'
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
