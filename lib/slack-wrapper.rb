require 'net/https'
require 'net/http/post/multipart'
require 'json'
require 'uri'

require_relative 'slack-wrapper/errors.rb'
require_relative 'slack-wrapper/config.rb'
require_relative 'slack-wrapper/api.rb'

module Slack
  extend self
  def id
    Slack::API::Auth.whoami['id']
  end
  def name
    Slack::API::Auth.whoami['name']
  end
end
