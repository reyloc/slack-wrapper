# https://api.slack.com/methods/chat.update
# https://api.slack.com/methods/chat.delete
# https://api.slack.com/methods/chat.postMessage
# https://api.slack.com/methods/chat.meMessage
# https://api.slack.com/methods/chat.postMessage
module Slack
  module API
    module Chat
      extend self
      def update(text, ts, channel, obj=nil)
        if Slack::API::Auth
          text = URI.escape(text)
          uri  = URI.parse('https://slack.com/api/chat.update')
          case obj
            when nil
              url = "#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&text=#{text}&as_user=true&ts=#{ts}"
            when Array
              url = "#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&text=#{text}&as_user=true&attachments=#{URI.escape(obj.to_json)}&ts=#{ts}"
            else
              Slack::Errors.new({'error'  => 'invalid_attachment',
                                 'detail' => 'Attachment object must be an Array'})
          end
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new(url)
          resp = http.request(req)
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
      def delete(ts, channel)
        if Slack::API::Auth
          text = URI.escape(text)
          uri  = URI.parse('https://slack.com/api/chat.delete')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&as_user=true&ts=#{ts}")
          resp = http.request(req)
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
      def post(text, channel, obj=nil)
        if Slack::API::Auth
          text = URI.escape(text)
          uri  = URI.parse('https://slack.com/api/chat.postMessage')
          case obj
            when nil
              url = "#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&text=#{text}&as_user=true"
            when Array
              url = "#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&text=#{text}&as_user=true&attachments=#{URI.escape(obj.to_json)}"
            else
              Slack::Errors.new({'error'  => 'invalid_attachment',
                                 'detail' => 'Attachment object must be an Array'})
          end
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new(url)
          resp = http.request(req)
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
      def post_me(text, channel)
        if Slack::API::Auth
          text = URI.escape(text)
          uri  = URI.parse('https://slack.com/api/chat.meMessage')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&text=#{text}")
          resp = http.request(req)
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
      def post_ephemeral(text, channel, user, obj=nil)
        if Slack::API::Auth
          text = URI.escape(text)
          uri  = URI.parse('https://slack.com/api/chat.postEphemeral')
          case obj
            when nil
              url = "#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&text=#{text}&as_user=true&user=#{user}"
            when Array
              url = "#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&text=#{text}&as_user=true&user=#{user}&attachments=#{URI.escape(obj.to_json)}"
            else
              Slack::Errors.new({'error'  => 'invalid_attachment',
                                 'detail' => 'Attachment object must be an Array'})
          end
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new(url)
          resp = http.request(req)
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
    class << self
    end
  end
end
