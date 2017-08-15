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
    return false
  end
end
