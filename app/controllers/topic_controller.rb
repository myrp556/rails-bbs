class TopicController < ApplicationController
  def home
    id = params[:id]
    @page = params[:page]
    if ! @page
      @page = 0
    end
    if ! id
      redirect_to '/'
    end
    @topic = Topic.find_by(id: id)
    if ! @topic
      redirect_to '/'
    end
    @zone = @topic.zone
    @notes = @topic.notes
  end
end
