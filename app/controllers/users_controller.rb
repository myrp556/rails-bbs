class UsersController < ApplicationController
  def detail
    @user = User.find(params[:id])
    if @user.nil?
      render plain: "no user"
      return
    end

    #debugger
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save

    else
      render 'new'
    end
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :name, :mail, \
                                  :password, :password_confirmation)
    end
end
