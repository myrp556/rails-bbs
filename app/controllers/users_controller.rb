class UsersController < ApplicationController
  include PrivilegeHelper
  include UsersHelper
  before_action :require_user, except: [:new, :create, :list, :search_user_name, :add_user_favorite, :delete_user_favorite]
  before_action :require_login, except: [:new, :create]
  before_action :require_user_self, only: [:update_detail, :update_icon]
  before_action :require_admin, only: [:destroy]
  before_action :require_rank, only: [:list]
  before_action :require_has_manage_or_rank, only: [:manage]
  before_action :require_zone, only: [:get_user_ball, :set_user_ball, :cancle_user_ball]
  before_action :require_manage_zone, only: [:set_user_ball, :cancle_user_ball]

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
    @users = @users.paginate(page: params[:page], per_page: Settings.user_lines_per_page)
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = t :signup_success
      redirect_to signin_url
    else
      flash[:danger] = make_error_message(@user)
      render 'new'
    end
  end

  def detail
  end

  def update_detail
    if @user.update_attributes(user_update_params)
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
    redirect_to user_list_url
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
    duration_s = get_ball_duration_s(@user, @zone.id)
    if duration_s == ''
      status = 'normal'
      message = t :normal
    else
      status = 'balling'
      message = t :balling
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

  def favorites
    @topics = get_user_favorite_topics()
  end

  def add_user_favorite
    topic_id = params[:topic_id]
    topic = Topic.find_by(id: topic_id)
    if topic.nil?
      respond_to do |format|
        format.json { render json: {'message': 'no topic'}, status: 'error' }
      end
    else
      favorite = @current_user.favorites.find_by(topic_id: topic_id)
      if favorite.nil?
        favorite = @current_user.favorites.new(topic_id: topic_id)
        if favorite.save()
          respond_to do |format|
            format.json { render json: {'message': 'success'} }
          end
        else
          respond_to do |format|
            format.json { render json: {'message': make_error_message(favorite)}, status: 'error' }
          end
        end
      else
        respond_to do |format|
          format.json { render json: {'message': 'success'} }
        end
      end
    end
  end

  def delete_user_favorite
    topic_id = params[:topic_id]
    topic = Topic.find_by(id: topic_id)
    if !topic.nil?
      favorite = @current_user.favorites.find_by(topic_id: topic_id)
      favorite.destroy() if !favorite.nil?
    end
    respond_to do |format|
      format.json { render json: {'message':'success'} }
    end
  end

  def search_user_name
    @users = User.where('name LIKE ?', "%#{params[:search]}%").first(5)
    puts @users
    names = []
    for user in @users
      names.push user.name
    end
    respond_to do |format|
      format.json { render json: {'names': names} }
    end
  end

  private
    def user_params
      params.require(:user).permit(:user_name, :name, :mail, :number, \
                                  :password, :password_confirmation)
    end

    def user_update_params
      params.require(:user).permit(:mail, :password, :password_confirmation)
    end

    def icon_params
      return {:file => nil} if params[:icon].nil?
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
      end
    end

    def require_user_self
      if !is_user_self?(@user)
        respond_to do |format|
          format.html { (flash[:danger] = t(:no_privilege)) and (redirect_to('/')) and return }
        end
      end
    end

    def require_rank
      if !is_high_rank_user?
        respond_to do |format|
          format.html { (flash[:danger] = t(:no_privilege)) and (redirect_to('/')) and return }
        end
      end
    end

    def require_has_manage_or_rank
      if !has_zone_manage? and !is_high_rank_user?
        respond_to do |format|
          format.html { (flash[:danger] = t(:require_privilege)) and (redirect_to('/')) and return}
        end
      end
    end

    def require_admin
      if !is_super_user?
        respond_to do |format|
          format.html { (flash[:danger] = t(:no_privilege)) and (redirect_to('/')) and return }
        end
      end
    end

    def require_login
      if !logged_in?
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

    def require_manage_zone
        if !is_manage_zone?(@zone) and !is_super_user?
          respond_to do |format|
            format.html { (flash[:danger] = (t :require_privilege)) and redirect_to(user_manage_url(id: @user.id)) and return }
            format.json { render(json: {"message": "require privilege"}, status: "error")}
          end
        end
    end

end
