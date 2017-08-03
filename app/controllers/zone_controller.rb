class ZoneController < ApplicationController
  # get zone, and topics
  # @zone
  # @topics
  before_action :pre_action
  # require @zone, or redirect
  before_action :require_content

  def main
    if !params[:id]
      redirect_to '/'
    end
    @zone = Zone.find_by(id: params[:id])
    if ! @zone
      redirect_to '/'
    end
    @topics = @zone.topics
    @topic = @zone.topics.new
  end

  private
    def pre_action
      @zone = Zone.find_by(id: params[:id])
      @topics = @zone.topics if !@zone.nil?
    end

    def require_content
      if @zone.nil?
        redirect_to '/'
      end
    end
end
