module PrivilegeHelper
  def is_user_self?(user)
    return false if @current_user.nil?
    @current_user.id == user.id
  end

  def is_manage_zone?(zone)
    return false if @current_user.nil?
    return false if @current_user.zones.nil?
    for z in @current_user.zones
      if z.id == zone.id
        return true
      end
    end
    return false
  end

  def is_super_user?
    !@current_user.nil? and @current_user.is_admin?
  end

  def is_high_rank_user?
    !@current_user.nil? and @current_user.high_rank?
  end

  def has_ball?(user, zone_id)
    return false if user.nil?
    ball = user.balls.find_by(zone_id: zone_id)
    if !ball.nil? and ball.expire > Time.current()
      return true
    end
    return false
  end

  def get_ball_duration_s(user, zone_id)

    ball = user.balls.find_by(zone_id: zone_id)
    duration_s = ''
    if ball.nil? or ball.expire.nil?
      return ''
    else
      if ball.expire < Time.zone.now
        ball.destroy
      else
        #message = t :balling
        #status = 'balling'
        second = (ball.expire - Time.current()).to_i
        minute = second/60.to_i
        hour = minute/60.to_i
        day = hour/24.to_i
        hour = hour - day*24.to_i
        minute = minute - day*24*60.to_i - hour*60.to_i
        if day == 0 and hour == 0
          minute += 1
        end
        duration_s = ''
        if t(:lang) == 'en'
          duration_s += day>0 ? (day.to_s + 'day'.pluralize(day)) : ''
          duration_s += hour>0 ? (hour.to_s + 'hour'.pluralize(hour)) : ''
          duration_s += minute>0 ? (minute.to_s + 'minute'.pluralize(minute)) : ''
        else
          duration_s += day>0 ? (day.to_s + t(:day)) : ''
          duration_s += hour>0 ? (hour.to_s + t(:hour)) : ''
          duration_s += minute>0 ? (minute.to_s + t(:minute)) : ''
        end
      end
    end
    return duration_s
  end

  def self_has_ball?(zone_id)
      has_ball?(@current_user, zone_id)
  end

  def has_zone_manage?
    !@current_user.zones.nil? and @current_user.zones.size() > 0
  end
end
