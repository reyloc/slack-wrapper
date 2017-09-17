# https://api.slack.com/methods/rtm.connect
# https://api.slack.com/methods/rtm.start
module Slack
  module API
    module RTM
      extend self
      def connect(opts={})
        if Slack::API::Auth
          opts['token'] = Slack::Config.token
          uri = URI.parse('https://slack.com/api/rtm.connect')
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['url']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def start(opts={})
        opts['no_unreads'] = true unless opts.key? 'no_unreads'
        opts['simple_latest'] = true unless opts.key? 'simple_latest'
        opts['token'] = Slack::Config.token
        if Slack::API::Auth
          uri = URI.parse('https://slack.com/api/rtm.start')
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
    end
    class << self
      def rtm
        RTM
      end
    end
  end
end
