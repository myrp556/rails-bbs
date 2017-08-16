class UsersController < ApplicationController
  include PrivilegeHelper
  before_action :require_user, except: [:new, :create, :list]
  before_action :get_login, except: [:new, :create]
  before_action :require_login, except: [:new, :create]
  #before_action :require_user, only: [:manage, :get_user_ball, :set_user_ball, :cancle_user_ball]
  before_action :require_zone, only: [:get_user_ball, :set_user_ball, :cancle_user_ball]
  before_action :zone_manage_require, only: [:set_user_ball, :cancle_user_ball]

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

  def manage
    @zones = Zone.all
  end

  def get_user_manage_zones
    ret = []
    for zone in @user.zones
      ret.push({'name': zone.name, 'id': zone.id})
    end
    respond_to do |format|
      format.json { render json: ret }
    end
  end

  def post_user_manage_zones
    for zone in @user.zones
      @user.zones.delete(zone)
    end
    if !params[:ids].nil? and params[:ids]
      for zone_id in params[:ids]
        @user.zones << Zone.find_by(id: zone_id)
      end
    end
    respond_to do |format|
      format.json { render json: {'message': 'update success'}}
    end
  end

  def get_user_ball
    ball = @user.balls.find_by(zone_id: @zone.id)
    duration_s = 0
    if ball.nil? or ball.expire.nil?
      message = t :normal
      status = 'normal'
    else
      if ball.expire < Time.zone.now
        message = t :normal
        status = 'normal'
        ball.destroy
      else
        message = t :balling
        status = 'balling'
        second = (ball.expire - Time.current()).to_i
        minute = second/60.to_i
        hour = minute/60.to_i
        day = hour/24.to_i
        hour = hour - day*24.to_i
        minute = minute - day*24*60.to_i - hour*60.to_i
        if day == 0 and hour == 0
          minute += 1
        end
        duration_s = ''
        if t(:lang) == 'en'
          duration_s += day>0 ? (day.to_s + 'day'.pluralize(day)) : ''
          duration_s += hour>0 ? (hour.to_s + 'hour'.pluralize(hour)) : ''
          duration_s += minute>0 ? (minute.to_s + 'minute'.pluralize(minute)) : ''
        else
          duration_s += day>0 ? (day.to_s + t(:day)) : ''
          duration_s += hour>0 ? (hour.to_s + t(:hour)) : ''
          duration_s += minute>0 ? (minute.to_s + t(:minute)) : ''
        end
      end
    end

    respond_to do |format|
      format.json { render json: {'message': message, 'status': status, 'duration_s': duration_s, 'user_id': @user.id, 'zone_id': @zone.id} }
    end
  end

  def set_user_ball
    ball = @user.balls.find_by(zone_id: @zone.id)
    ball = @user.balls.create(zone_id: @zone.id) if ball.nil?
    day = params[:day].nil? ? 0 : params[:day].to_i
    hour = params[:hour].nil? ? 0 : params[:hour].to_i
    minute = params[:minute].nil? ? 0 : params[:minute].to_i
    tot = day.days + hour.hours + minute.minutes
    ball.update(expire: tot.from_now)

    respond_to do |format|
      format.json { render json: {'message': ball.expire, 'user_id': @user.id, 'zone_id': @zone.id}}
    end
  end

  def cancle_user_ball
    ball = @user.balls.find_by(zone_id: @zone_id)
    ball.destroy if !ball.nil?

    respond_to do |format|
      format.json { render json: {'message': 'success', 'user_id': @user.id, 'zone_id': @zone.id} }
    end
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
      user_id = params[:id]
      user_id = params[:user_id] if user_id.nil?
      @user=User.find_by(id: user_id)
      if @user.nil?
        respond_to do |format|
          format.html { redirect_to '/' and return }
          format.json { render(json: {'message': 'no user'}, status: 'error') and return }
        end
        #redirect_to '/'
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

    def require_zone
      @zone = Zone.find_by(id: params[:zone_id])
      if @zone.nil?
        respond_to do |format|
          format.html { redirect_to(user_manage_url(id: @user.id)) and return  }
          format.json { render(json: {'message':'no zone found'}, status: 'error') and return }
        end
      end
    end

    def zone_manage_require
        if !is_manage_zone?(@zone) and !is_super_user?
          respond_to do |format|
            format.html { (flash[:danger] = (t :require_privilege)) and redirect_to(user_manage_url(id: @user.id)) and return }
            format.json { render(json: {"message": "require privilege"}, status: "error")}
          end
        end
    end

end
