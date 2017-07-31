class ZoneController < ApplicationController
  def home
    if !params[:id]
      redirect_to '/'
    end
    @zone = Zone.find_by(id: params[:id])
    if ! @zone
      redirect_to '/'
    end
    @topics=@zone.topics
  end
end
