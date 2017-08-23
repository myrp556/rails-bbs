class TopicController < ApplicationController
  include PrivilegeHelper
  include NoteHelper
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
  before_action :pre_action_note, only: [:create_note, :edit_note, :update_note, :destroy_note, :reply_to_note]
  # require @zone, @topic, or redirect page!
  before_action :require_content_topic, only: [:main, :create_note]
  # require @note or redirect
  before_action :require_content_note, except: [:main, :create_note]
  before_action :get_login
  before_action :require_login, only: [:create_note, :edit_note, :update_note, :destroy_note, :reply_to_note]
  before_action :edit_require, only: [:edit_note, :update_note]
  before_action :delete_require, only: [:destroy_note]
  before_action :require_no_ball, only: [:create_note, :edit_note, :update_note, :destroy_note]
  #before_action :require_privilege, only: [:edit_note, :update_note, :destroy_note]

  def main
    @url = new_reply_url(topic_id: @topic.id)
    @note = @topic.notes.new
    if !@topic.nil?
      @base_url = "/topic?id=#{@topic.id}"
      #@notes = make_up_page(@topic.notes, Settings.note_lines_per_page)
      @notes = @topic.notes.paginate(page: params[:page], per_page: Settings.note_lines_per_page)
      #@notes = @topic.notes
    end
  end

## actions for notes
  def create_note
    if !@topic.nil? and !@zone.nil?
      floor = @topic.floor_count
      @note = @topic.notes.new()
      @note.assign_attributes(permit_params_note(params))
      @note.zone_id = @zone.id
      if @note.valid? and @note.save()
        @note.update(floor: floor + 1)
        @note.update(user: @current_user)
        @topic.update(floor_count: floor + 1)
        @topic.update(last_user_id: @current_user.id)
        page = get_page(@topic.notes, @note, Settings.note_lines_per_page)

        redirect_to topic_url(id: @topic.id) + "&page=#{page}#floor#{@note.floor}"
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
      page = get_page(@topic.notes, @note, Settings.note_lines_per_page)

      redirect_to topic_url(id: @topic.id) + "&page=#{page}#floor#{@note.floor}"
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

  def reply_to_note
    reply_params = permit_params_note_reply(params)
    reply_note = @topic.notes.new
    reply_note.note_detail = reply_params[:note_reply_detail]
    reply_note.zone_id = @zone.id
    if reply_note.valid? and reply_note.save()
      floor = @topic.floor_count
      reply_note.update(user: @current_user)
      reply_note.update(floor: floor+1)
      reply_note.update(reply_to: params[:id])
      reply_note.update(reply_to_user_id: @note.user_id)
      reply_note.update(parse_to: reply_params[:parse_to])
      @topic.update(floor_count: floor+1)
      @topic.update(last_user_id: @current_user.id)
      #page = get_page(@topic.notes, reply_note, Settings.note_lines_per_page)
      page = get_page(@topic.notes, @note, Settings.note_lines_per_page)

      #redirect_to topic_url(id: @topic.id) + "&page=#{page}#floor#{@note.floor}"
      respond_to do |format|
        format.json { render json: {'message': 'success', 'redirect': topic_url(id: @topic.id) + "&page=#{page}#floor#{@note.floor}" } }
      end
    else
      #flash[:danger] = make_error_message(@note)
      #redirect_to topic_url(id: topic.id)
      respond_to do |format|
        format.json { render json: {'message': make_error_message(reply_note)}, status: 'error' }
      end
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

    def edit_require
      if !is_user_self?(@note.user)
        flash[:danger] = t :require_privilege
        redirect_back
      end
    end

    def delete_require
      if !is_user_self?(@note.user) and !is_manage_zone?(@zone) and !is_super_user?
        flash[:danger] = t :require_privilege
        redirect_back
      end
    end

    def require_no_ball
      if has_ball?(@current_user, @zone.id)
        respond_to do |format|
          format.html { (flash[:danger] = t(:balling_zone)) and redirect_back and return }
          format.json { render(json: {'message': 'balling zone'}, status: 'error') and return }
        end
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

    def permit_params_note_reply(params)
      params.permit(:parse_to, :note_reply_detail)
    end

    def pre_action_topic
      @topic = Topic.find_by(id: params[:id])
      @zone = @topic.zone if !@topic.nil?
    end
end
