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
  before_action :pre_action_note, only: [:edit_note, :update_note, :destroy_note]
  # require @zone, @topic, or redirect page!
  before_action :require_content, only: [:edit_note, :destroy_note, :update_note]

  def main
    @page = params[:page]
    @url = new_reply_url(topic_id: @topic.id)
    if @page.nil?
      @page = 0
    end
    @note = @topic.notes.new
  end

  def create_topic
  end
## actions for notes
  def create_note
    if !@topic.nil? and !@zone.nil?
      floor = @topic.floor_count
      @note = @topic.notes.new()
      @note.assign_attributes(permit_params_note(params))
      #puts note
      #puts floor
      if @note.save()
        @topic.update_attribute(:floor_count, floor + 1)
        @note.update_attribute(:floor, floor + 1)
        redirect_to topic_url(id: @topic.id)
      else
        flash['danger'] = @note.errors.full_messages
        @notes = @topic.notes
        @zone = @topic.zone
        #render 'main', id: @topic.id
        redirect_to topic_url(id: @topic.id)
      end
    else
      flash['danger'] = 'no topic specifc!' + @topic + ' ' + @zone
      render 'main'
    end
  end

  def edit_note
    @url = update_reply_url(id: @note.id)
  end

  def update_note
    if @note.update_attributes(permit_params_note)
      redirect_to topic_url(id: @topic.id)
    else
      flash[:danger] = @note.errors.full_messages
      render 'edit_note'
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
      flash[:danger] = @note.errors_full_messages
      render 'main'
    end
  end

  private
    def pre_action_note
      @note = Note.find_by(id: params[:id]) if !params[:id].nil?
      @topic = Topic.find_by(id: params[:topic_id]) if !params[:topic_id].nil?
      @topic = @note.topic if @topic.nil? and !@note.nil?
      @zone = @topic.zone if !@topic.nil?
    end

    def require_content
      if @zone.nil?
        redirect_to "/"
      end
      if @topic.nil?
        redirect_to zone_url(id: @zone.id)
      end
    end

    def permit_params_note(params)
      params.require(:note).permit(:detail, :author_id, :author_name, :floor)
    end

    def pre_action_topic
      @topic = Topic.find_by(id: params[:id])
      @zone = @topic.zone if !@topic.nil?
      @notes = @topic.notes if !@topic.nil?
    end
end
