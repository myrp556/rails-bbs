class ZoneController < ApplicationController
  include PrivilegeHelper
  # get zone from id, and topics
  # @zone
  # @topics
  before_action :pre_action_zone, only: [:main, :edit_zone, :update_zone, :destroy_zone, :update_icon]
  # get topic from id, and get zone from zone_id or from topic
  # @topic
  # @zone
  before_action :pre_action_topic, only: [:create_topic, :edit_topic, :update_topic, :destroy_topic, :set_top_topic, :cancle_top_topic]
  # require @zone, or redirect
  before_action :require_content_zone, only: [:main, :create_topic, :edit_zone, :update_zone, :destroy_zone, :update_icon]
  # require @topic, or redirect
  #before_action :require_content_topic, except: [:main, :create_topic, :new_zone, :create_zone]
  before_action :require_content_topic, only: [:edit_topic, :update_topic, :delete_topic, :set_top_topic, :cancle_top_topic]
  before_action :get_login
  before_action :require_login, except: [:main]
  before_action :self_require, only: [:edit_topic, :update_topic]
  before_action :manage_require, only: [:destroy_topic, :set_top_topic, :cancle_top_topic]
  #before_action :require_privilege, only: [:edit_topic, :update_topic, :destroy_topic]

  def main
    @url = new_topic_url(zone_id: @zone.id)
    if params[:search]
      @topics = @zone.topics.where('topic_detail LIKE ?', "%#{params[:search]}%")
    else
      @topics = @zone.topics
    end
    if !@zone.nil?
      @base_url = "/zone?id=#{@zone.id}"
      #@topics = make_up_page(@topics, Settings.topic_lines_per_page)
      @topics = @topics.where("is_top = ?", FALSE).order('updated_at DESC').paginate(page: params[:page], per_page: Settings.topic_lines_per_page)
      if params[:page].nil? or params[:page]==1
        @top_topics = @zone.topics.where('is_top = ?', TRUE)
      end
      @topic = @zone.topics.new
    end 
  end

  def new_zone
    @url = "/new_zone"
    @zone = Zone.new
  end
  def create_zone
    @zone = Zone.new(permit_params_zone(params))
    if @zone.save
      flash[:success] = t :create_success
      redirect_to zone_url(id: @zone.id)
    else
      flash[:danger] = make_error_message(@zone)
      render 'new_zone'
    end
  end
  def edit_zone
    @url = update_zone_url(id: @zone.id)
  end
  def update_zone
    if @zone.update_attributes(permit_params_zone(params))
      flash[:success] = t :update_success
      redirect_to zone_url(id: @zone.id)
    else
      flash[:danger] = make_error_message(@zone)
      render 'edit_zone'
    end
  end

  def destroy_zone
    if @zone.destroy
      flash[:success] = t :delete_success
      redirect_to root_url
    else
      flash[:danger] = make_error_message(@zone)
      redirect_to zone_url(id: @zone.id)
    end
  end
  def update_icon
    icon = icon_params[:file]
    if valid_uploaded_file?(icon) and valid_image_file?(icon)
      file_name = update_public_icon(@zone.icon, icon)
      @zone.update(icon: file_name)

      flash[:success] = t :update_success
      redirect_to zone_url(id: @zone.id)
    else
      flash[:danger] = t :invalid_icon_file
      render 'edit_topic'
    end
  end

  def create_topic
    @topic = @zone.topics.new
    ps = permit_params_topic(params)
    @topic.topic_detail = ps[:topic_detail]
    if @topic.save
      @note = @topic.notes.new
      @note.note_detail = ps[:note_detail]
      if @note.save
        @topic.update(user: @current_user)
        @topic.update(floor_count: 1)

        @note.update(user: @current_user)
        @note.update(floor: 1)
      else
        @topic.destroy
        flash[:danger] = make_error_message(@note)
      end
      redirect_to zone_url(id: @zone.id)
    else
      flash[:danger] = make_error_message(@topic)
      redirect_to zone_url(id: @zone.id)
    end
  end

  def edit_topic
    @url = update_topic_url(id: @topic.id)
    if @topic.notes[0].floor==1
      @topic.note_detail = @topic.notes[0].note_detail
    end
  end

  def update_topic
    ps = permit_params_topic(params)
    @note = @topic.notes[0]
    @topic.topic_detail = ps[:topic_detail]
    @note.note_detail = ps[:note_detail]
    if @topic.valid? and @note.valid?
      @topic.save
      @note.save
    else
      flash[:danger] = make_error_message(@note)
    end
      redirect_to topic_url(id: @topic.id)
  end

  def destroy_topic
    if @topic.destroy
      redirect_to zone_url(id: @zone.id)
    else
      flash[:danger] = make_error_message(@topic)
      redirect_to zone_url(id: @zone.id)
    end
  end

  def set_top_topic
    @topic.update(is_top: true)
    redirect_to zone_url(id: @zone.id)
  end

  def cancle_top_topic
    @topic.update(is_top: false)
    redirect_to zone_url(id: @zone.id)
  end

  def get_zones
    ret = []
    for zone in Zone.all
      ret.push({'name': zone.name, 'id': zone.id})
    end
    respond_to do |format|
      format.json { render json:  ret }
    end
  end

  private
    def pre_action_zone
      @zone = Zone.find_by(id: params[:id])
      
    end

    def pre_action_topic
      @topic = Topic.find_by(id: params[:id])
      @zone = Zone.find_by(id: params[:zone_id])
      @zone = @topic.zone if @zone.nil? and !@topic.nil?
    end

    def require_content_zone
      if @zone.nil?
        respond_to do |format|
          format.html { redirect_to '/' }
          format.json { render json: {'message': 'zone_not_found'}, status: "error"}
        end
        return
      end
    end

    def require_content_topic
     if @topic.nil?
        respond_to do |format|
          format.html { redirect_to zone_url(id: @zone.id) }
          format.json { render json: {'message': "topic not found"}, status: "error"}
        end
        return
     end
    end

    def redirect_back
      if !@topic.nil?
        redirect_to topic_url(id: @topic.id)
        return
      end
      if !@zone.nil?
        redirect_to zone_url(id: @zone.id)
        return
      end
    end

    def get_login
      logged_in?
    end

    def require_login
      if @current_user.nil?
        flash[:info] = :require_first
        redirect_to login_url
        return
      end
    end

    def self_require
      if !is_user_self?(@topic.user)
        respond_to do |format|
          format.html { (flash[:danger] = (t :require_privilege)) and redirect_back and return }
          format.json { render(json: {"message": "require privilege"}, status: "error") and return}
        end
        return
      end
    end

    def manage_require
      if !is_user_self?(@topic.user) and !is_manage_zone?(@zone) and !is_super_user?
        respond_to do |format|
          format.html { (flash[:danger] = (t :require_privilege)) and redirect_back and return }
          format.json { render(json: {"message": "require privilege"}, status: "error") and return}
        end
        return
      end
    end

    def permit_params_zone(params)
      params.require(:zone).permit(:name, :description)
    end
    def permit_params_topic(params)
      params.require(:topic).permit(:topic_detail, :note_detail)
    end
end
