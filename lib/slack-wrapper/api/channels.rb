# https://api.slack.com/methods/channels.list
# https://api.slack.com/methods/channels.create
# https://api.slack.com/methods/channels.archive
# https://api.slack.com/methods/channels.unarchive
# https://api.slack.com/methods/channels.info
# https://api.slack.com/methods/channels.history
# https://api.slack.com/methods/channels.join
# https://api.slack.com/methods/channels.leave
# https://api.slack.com/methods/channels.invite
# https://api.slack.com/methods/channels.kick
# https://api.slack.com/methods/channels.rename
# https://api.slack.com/methods/channels.setPurpose
# https://api.slack.com/methods/channels.setTopic
module Slack
  module API
    module Channels
      extend self
      def get_channels(archived=false)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.list')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          if archived
            url = "#{uri.to_s}?token=#{Slack::Config.token}&exclude_members=true"
          else
            url = "#{uri.to_s}?token=#{Slack::Config.token}&exclude_archived=true&exclude_members=true"
          end
          req  = Net::HTTP::Post.new(url)
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['channels']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def all_channels
        get_channels(true)
      end
      def active_channels
        get_channels()
      end
      def search(term, archived=false, regex=false)
        channels = get_channels(archived)
        if regex
          channels.select{|c| c['name'] =~ /#{term}/}
        else
          channels.select{|c| c['name'] == term}.first
        end
      end
      def create(name, validate=false)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.create')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&name=#{name}&validate=#{validate}")
          resp = http.request(req)
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
      def archive(id)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.archive')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{id}")
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
      def unarchive(id)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.unarchive')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{id}")
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
      def info(id)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.info')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{id}")
          resp = http.request(req)
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
      def history(id, count)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.history')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{id}&count=#{count}")
          resp = http.request(req)
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
      def join(name)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.join')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&name=#{name}")
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
      def leave(id)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.join')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{id}")
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
      def invite_user(user, channel)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.invite')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&user=#{user}")
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
      def kick_user(user, channel)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.kick')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{channel}&user=#{user}")
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
      def rename(id, name)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.rename')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{id}&name=#{name}")
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
      def set_purpose(id, text)
        text = URI.escape(text)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.setPurpose')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{id}&purpose=#{text}")
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
      def set_topic(id, text)
        text = URI.escape(text)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/channels.setTopic')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&channel=#{id}&topic=#{text}")
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
