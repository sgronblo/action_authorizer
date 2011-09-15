require 'test/unit'
require 'lib/action_authorizer'

class ActionAuthorizerTest < Test::Unit::TestCase

  def setup
    permissions = {
      'super_admin' => {
        '*' => ['*']
      },
      'wiki_editing' => {
        'wiki' => ['*']
      },
      'read_only_actions' => {
        '*' => ['show', 'index']
      },
      'normal_user' => {
        'project' => ['index', 'show']
      }
    }
    @action_authorizer = ActionAuthorizer.new(permissions)
  end

  def test_if_action_group_allows_any_controller_and_any_action_it_should_be_allowed
    action_group_names = ['super_admin', 'normal_user']
    assert @action_authorizer.authorize('admin/user', 'change_password', action_group_names)
  end

  def test_should_permit_an_allowed_action
    action_group_names = ['normal_user']
    assert @action_authorizer.authorize('project', 'index', action_group_names)
  end

  def test_should_throw_an_exception_if_an_undefined_action_group_name_is_used
    action_group_names = ['this_group_name_is_undefined']
    assert_raises(ArgumentError) do
      @action_authorizer.authorize('project', 'index', action_group_names)
    end
  end

  def test_should_not_permit_a_disallowed_action
    action_group_names = ['normal_user']
    assert_equal(false, @action_authorizer.authorize('admin/user', 'change_password', action_group_names))
  end

  def test_should_be_able_to_allow_any_action_for_a_controller
    action_group_names = ['wiki_editing']
    assert @action_authorizer.authorize('wiki', 'update', action_group_names)
    assert @action_authorizer.authorize('wiki', 'delete', action_group_names)
  end

  def test_should_be_able_to_allow_an_action_for_all_controllers
    action_group_names = ['read_only_actions']
    assert @action_authorizer.authorize('projects', 'index', action_group_names)
    assert @action_authorizer.authorize('projects', 'show', action_group_names)
    assert @action_authorizer.authorize('users', 'index', action_group_names)
    assert @action_authorizer.authorize('users', 'show', action_group_names)
    assert_equal(false, @action_authorizer.authorize('users', 'delete', action_group_names))
  end

end
