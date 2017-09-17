# https://api.slack.com/methods/bots.info
module Slack
  module API
    module Bots
      extend self
      def info(opts={})
        if Slack::API::Auth
          opts['token'] = Slack::Config.token
          uri = URI.parse('https://slack.com/api/bots.info')
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['bot']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
    end
  end
end
