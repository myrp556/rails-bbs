class UsersController < ApplicationController
  before_action :require_login, except: [:new, :create]

  def detail
    #@user = User.find(params[:id])
    if @user.nil?
      render plain: "no user"
      return
    end

    #debugger
  end

  def new
    @user = User.new
    @url = '/signup'
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to '/'
    else
      render 'new'
    end
  end

  def edit
    #@user = User.find(params[:id])
    @url = '/user/update'
    if @user.nil
      redirect_to '/'
    end
  end

  def passwd

  end

  def update
    #@user = User.find(params[:id])
  end

  def destroy
    #@user = User.find(params[:id])
  end

  def passwd
  end

  def passwd_update

  end

  def mail_update
    @user.update_attribute(user_params)
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :name, :mail, :number, \
                                  :password, :password_confirmation)
    end

    def require_login
      @user=User.find_by(id: params[:id])
      if @user.nil?
        redirect_to '/'
      end
    end
end
