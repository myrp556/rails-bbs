class UsersController < ApplicationController
  before_action :require_user, except: [:new, :create, :list]
  before_action :get_login, except: [:new, :create]
  before_action :require_login, except: [:new, :create]

  def new
    @user = User.new
    @url = '/signup'
  end

  def list
    if params[:search]
      @users = User.where('name LIKE ? OR user_name LIKE ? OR mail LIKE ?', "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
    else
      @users = User.all
    end
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
    if @user.update_attributes(params_without_icon(user_params))
      flash[:success] = t :update_success
      redirect_to user_detail_url(id: @user.id)
    else
      flash[:danger] = make_error_message(@user)
      render 'detail'
    end
  end

  def update_icon
    icon = icon_params[:file]
    puts icon
    if valid_uploaded_file?(icon) and valid_image_file?(icon)
      file_name = update_public_icon(@user.icon, icon)
      @user.update(icon: file_name)

      flash[:success] = t :update_success
      redirect_to user_detail_url(id: @user.id)
    else
      flash[:danger] = t :invalid_icon_file
      render 'detail'
    end
  end

  def destroy
    #@user = User.find(params[:id])
    delete_public_icon(@user.icon)
    @user.destroy

  end

  private
    def user_params
      params.require(:user).permit(:user_name, :name, :mail, :number, \
                                  :password, :password_confirmation, :icon)
    end

    def icon_params
      params.require(:icon).permit(:file)
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
        redirect_to login_url
      end
    end

end
