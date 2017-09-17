module Slack
  module Config
    extend self
    attr_accessor :token, :logger
    def reset
      self.token  = ENV['SLACK_TOKEN'] ? ENV['SLACK_TOKEN'] : nil
      self.logger = ENV['LOG_LEVEL'] ? ENV['LOG_LEVEL'] : nil
    end
    reset
  end
  class << self
    def configure
      block_given? ? yield(Config) : Config
    end
    def config
      Config
    end
  end
end
