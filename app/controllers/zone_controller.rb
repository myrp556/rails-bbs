class ZoneController < ApplicationController
  # get zone from id, and topics
  # @zone
  # @topics
  before_action :pre_action_zone, only: [:main]
  # get topic from id, and get zone from zone_id or from topic
  # @topic
  # @zone
  before_action :pre_action_topic, only: [:create_topic, :edit_topic, :update_topic, :destroy_topic]
  # require @zone, or redirect
  before_action :require_content_zone, only: [:main, :create_topic]
  # require @topic, or redirect
  before_action :require_content_topic, except: [:main, :create_topic]

  def main
    @url = new_topic_url(zone_id: @zone.id)
    @page = params[:page]
    if @page.nil?
      @page = 0
    end
    @topic = @zone.topics.new
  end

  def create_topic
    @topic = @zone.topics.new
    ps = permit_params(params)
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
        flash[:danger] = 'topic note content not valid!'
      end
      redirect_to zone_url(id: @zone.id)
    else
      flash[:danger] = 'topic not valid!'
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
    ps = permit_params(params)
    @note = @topic.notes[0]
    @topic.topic_detail = ps[:topic_detail]
    @note.note_detail = ps[:note_detail]
    if @topic.valid? and @note.valid?
      @topic.save
      @note.save
    else
      flash[:danger] = 'update not valid'
    end
      redirect_to topic_url(id: @topic.id)
  end

  def destroy_topic
    if @topic.destroy
      redirect_to zone_url(id: @zone.id)
    else
      flash[:dange] = 'delete topic faild! ' + @topic.errors.full_messages[0]
      redirect_to zone_url(id: @zone.id)
    end
  end

  private
    def pre_action_zone
      @zone = Zone.find_by(id: params[:id])
      @topics = @zone.topics if !@zone.nil?
    end

    def pre_action_topic
      @topic = Topic.find_by(id: params[:id])
      @zone = Zone.find_by(id: params[:zone_id])
      @zone = @topic.zone if !@topic.nil?
    end

    def require_content_zone
      if @zone.nil?
        redirect_to root_url
      end
    end

    def require_content_topic
     if @topic.nil?
        redirect_to zone_url(id: @zone.id)
     end
    end

    def get_login
      logged_in?
    end

    def require_login
      if @current_user.nil?
        flash[:info] = '请先登录!'
        redirect_back
      end
    end

    def require_privilege
      if @current_user.nil? or @topic.nil? or @topic.user.id != @current_user.id
        flash[:danger] = '没有操作权限!'
        redirect_back
        return
      end
    end

    def redirect_back
      if !@topic.nil?
        redirect_to topic_url(id: @topic.id)
      end
      if !@zone.nil?
        redirect_to zone_url(id: @zone.id)
      end
    end

    def permit_params(params)
      params.require(:topic).permit(:topic_detail, :note_detail)
    end
end
