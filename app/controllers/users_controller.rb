class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create]
  before_action :get_login, except: [:new, :create]
  before_action :require_login, except: [:new, :create]

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
      flash[:success] = t :update_success
      redirect_to user_detail_url(id: @user.id)
    else
      flash[:danger] = make_error_message(@user)
      render 'detail'
    end
  end

  def destroy
    #@user = User.find(params[:id])
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

    def get_login
      logged_in?
    end

    def require_login
      if @current_user.nil?
        flash[:info] = t :login_first
        redirect_to root_url
      end
    end

end
