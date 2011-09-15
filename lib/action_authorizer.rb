require 'yaml'

class ActionAuthorizer

  def initialize(action_groups)
    @action_groups = action_groups
  end

  def authorize(controller, action, action_group_names)
    action_group_names.each do |action_group_name|
      if @action_groups.has_key? action_group_name
        return true if authorize_action(controller, action, @action_groups[action_group_name])
      else
        raise ArgumentError, "Undefined action group #{action_group_name}", caller
      end
    end
    return false
  end

  private
  def authorize_action(controller, action, permissions)
    # Check wildcards first
    if permissions.has_key? "*"
      if permissions["*"].include? "*"
        return true
      elsif permissions["*"].include? action
        return true
      end
    elsif permissions.has_key? controller
      if permissions[controller].include? "*"
        return true
      else
        return permissions[controller].include? action
      end
    else
      return false
    end
  end

end
