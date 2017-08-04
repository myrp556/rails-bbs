class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]

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

  def detail
  end

  def update_detail
    if @user.update_attributes(user_params)
      flash[:success] = '更新成功'
      redirect_to user_detail_user(id: @user.id)
    else
      flash[:danger] = @user.errors.full_messages[0]
      render 'user_detail'
    end
  end

  def passwd

  end

  def update_passwd
    #@user = User.find(params[:id])
  end

  def destroy
    #@user = User.find(params[:id])
  end

  def passwd
  end

  def passwd_update

  end

  def update_detail
    @user.update_attributes(user_params)
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :name, :mail, :number, \
                                  :password, :password_confirmation)
    end

    def require_user
      @user=User.find_by(id: params[:id])
      if @user.nil?
        redirect_to '/'
      end
    end
end
