module UsersHelper
  def get_user_favorite_topics
    ret = []
    for favorite in @current_user.favorites
      topic = Topic.find_by(id: favorite.topic_id)
      if !topic.nil?
        ret.push topic
      else
        favorite.destroy
      end
    end
    ret
  end

  def has_favorite_topic?(topic)
    !@current_user.favorites.find_by(topic.id).nil?
  end

  def has_rate_point?
    @current_user.rate_point > 0
  end
end
