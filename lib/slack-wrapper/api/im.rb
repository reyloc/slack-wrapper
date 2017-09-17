# https://api.slack.com/methods/im.open
# https://api.slack.com/methods/im.close
# https://api.slack.com/methods/im.history
# https://api.slack.com/methods/im.list
module Slack
  module API
    module IM
      extend self
      def open(id, opts={})
        if Slack::API::Auth
          opts['user'] = id
          opts['return_im'] = true
          opts['token'] = Slack::Config.token
          opts['include_locale'] = true
          uri = URI.parse('https://slack.com/api/im.open')
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['channel']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def close(id, opts={})
        if Slack::API::Auth
          opts['channel'] = id
          opts['token'] = Slack::Config.token
          uri = URI.parse('https://slack.com/api/im.close')
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            true
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def history(id, opts={})
        if Slack::API::Auth
          opts['channel'] = id
          opts['token'] = Slack::Config.token
          uri = URI.parse('https://slack.com/api/im.history')
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['messages']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def list(opts={})
        if Slack::API::Auth
          opts['token'] = Slack::Config.token
          uri = URI.parse('https://slack.com/api/im.list')
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['ims']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
    end
    class << self
      def im
        IM
      end
    end
  end
end
