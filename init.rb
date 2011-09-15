require 'yaml'
require 'action_authorizer'

permissions_config_file = File.expand_path(File.join('config', 'permissions.yml'), Rails.root)

action_authorizer = ActionAuthorizer.new(YAML.load_file(permissions_config_file))
