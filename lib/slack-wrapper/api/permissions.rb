# https://api.slack.com/methods/apps.permissions.info
# https://api.slack.com/methods/apps.permissions.request
# Slack API still in development for feature, leaving as is for now
module Slack
  module API
    class Permissions
      def show(opts={})
        if Slack::API::Auth
          opts['token'] = Slack::Config.token
          uri = URI.parse('https://slack.com/api/apps.permissions.info')
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['info']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def request(opts={})
        if Slack::API::Auth
          if opts.key?('scopes') && opts.key?("trigger_id")
            Slack::Errors.new({'error' => 'no_scope', 'detail' => 'You must provide a comma separated scope'}) if opts['scopes'].empty?
            Slack::Errors.new({'error' => 'no_trigger_id', 'detail' => 'You must provide a trigger id'}) if opts['trigger_id'].empty?
          else
            Slack::Errors.new({'error' => 'invalid_parameters', 'detail' => 'You must provide both scopes and trigger_id as options'})
          end
          opts['token'] = Slack::Config.token
          uri = URI.parse('https://slack.com/api/apps.permissions.info')
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
    end
  end
end
