module ActionAuthorizer

  def self.authorize_action(controller, action, permissions)
    # Check wildcards first
    if permissions.has_key? "*"
      if permissions["*"].contain? "*"
        return true
      elsif permissions["*"].contain? action
        return true
      end
    elsif permissions.has_key? controller
      if permissions[controller].contain? "*"
        return true
      else
        return permissions[controller].contain? action
      end
    else
      return false
    end
  end

  def self.authorize(controller, action, action_group_names)
    action_group_names.each do |action_group_name|
      if self.ACTION_GROUPS.contain? action_group_name
        return true if authorize_action(controller, action, self.ACTION_GROUPS[action_group_name])
      else
        raise ArgumentError, "Undefined action group #{action_group_name}", caller
      end
    end
    return false
  end

  ACTION_GROUPS = {}

end
