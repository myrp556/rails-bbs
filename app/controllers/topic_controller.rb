class TopicController < ApplicationController
  # get topic form id, and get zone, notes
  # params
  # @topic
  # @zone
  # @notes
  before_action :pre_action_topic, only: [:main]
  # get note from id, and get topic or from topic_id and zone
  # params
  # @note
  # @topic
  # @zone
  before_action :pre_action_note, only: [:create_note, :edit_note, :update_note, :destroy_note]
  # require @zone, @topic, or redirect page!
  before_action :require_content_topic, only: [:main, :create_note]
  # require @note or redirect
  before_action :require_content_note, except: [:main, :create_note]
  before_action :get_login
  before_action :require_login, only: [:create_note, :edit_note, :update_note, :destroy_note]
  before_action :require_privilege, only: [:edit_note, :update_note, :destroy_note]

  def main
    @url = new_reply_url(topic_id: @topic.id)
    @page = params[:page]
    if @page.nil?
      @page = 0
    end
    @note = @topic.notes.new
  end

## actions for notes
  def create_note
    if !@topic.nil? and !@zone.nil?
      floor = @topic.floor_count
      @note = @topic.notes.new()
      @note.assign_attributes(permit_params_note(params))
      #puts note
      #puts floor
      if @note.valid? and @note.save()
        @topic.update(floor_count: floor + 1)
        @note.update(floor: floor + 1)
        #@note.update(author_id: @current_user.id)
        #@note.update(author_name: @current_user.name)
        @note.update(user: @current_user)
        redirect_to topic_url(id: @topic.id)
      else
        flash['danger'] = make_error_message(@note)
        @notes = @topic.notes
        @zone = @topic.zone
        #render 'main', id: @topic.id
        redirect_to topic_url(id: @topic.id)
      end
    else
      #flash['danger'] = 'no topic specifc!' + @topic + ' ' + @zone
      redirect_to topic_url(id: @topic.id)
    end
  end

  def edit_note
    @url = update_reply_url(id: @note.id)
  end

  def update_note
    if @note.update_attributes(permit_params_note(params))
      redirect_to topic_url(id: @topic.id)
    else
      flash[:danger] = make_error_message(@note)
      redirect_to edit_reply_url(id: @note.id)
    end
  end

  def destroy_note
    if @note.destroy
      if @topic.notes.size == 0
        @topic.destroy
        redirect_to zone_url(id: @zone.id)
      else
        redirect_to topic_url(id: @topic.id)
      end
    else
      flash[:danger] = make_error_message(@note)
      redirect_to topic_url(id: @topic.id)
    end
  end

  private
    def pre_action_note
      @note = Note.find_by(id: params[:id]) if !params[:id].nil?
      @topic = Topic.find_by(id: params[:topic_id]) if !params[:topic_id].nil?
      @topic = @note.topic if @topic.nil? and !@note.nil?
      @zone = @topic.zone if !@topic.nil?
    end

    def require_content_topic
      if @zone.nil?
        redirect_to root_url
      end
      if @topic.nil?
        redirect_to zone_url(id: @zone.id)
      end
    end

    def require_content_note
      if @note.nil?
        redirect_to topic_url(id: @topic.id)
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

    def require_privilege
      if !@current_user or @note.user.id != @current_user.id
        flash[:danger] = t :require_privilege
        redirect_back
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
      redirect_to root_url
      return
    end
    def permit_params_note(params)
      params.require(:note).permit(:note_detail)
    end

    def pre_action_topic
      @topic = Topic.find_by(id: params[:id])
      @zone = @topic.zone if !@topic.nil?
      @notes = @topic.notes if !@topic.nil?
    end
end
