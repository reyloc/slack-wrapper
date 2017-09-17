# https://api.slack.com/methods/users.info
# https://api.slack.com/methods/users.list
# https://api.slack.com/methods/users.profile.get
# https://api.slack.com/methods/users.profile.set
module Slack
  module API
    module Users
      extend self
      def info(id)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/users.info')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&user=#{id}")
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['user']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def get_list()
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/users.list')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&presence=false")
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['members']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def search(term, what='username', regex=false)
        users = get_list()
        out = nil
        case what
          when 'email'
            out = users.select{|u| u['profile']['email'] == term} unless regex
            out = users.select{|u| u['profile']['email'] =~ /#{term}/}.first if regex
          when 'username'
            out = users.select{|u| u['name'] == term}.first unless regex
            out = users.select{|u| u['name'] =~ /#{term}/} if regex
          when 'name'
            out = users.select{|u| u['profile']['real_name'] == term}.first unless regex
            out = users.select{|u| u['profile']['real_name'] =~ /#{term}/} if regex
          else
            Slack::Errors.new({"error"   => "invalid_search_term",
                               "detail"  => "You can only search by username, name, or email"})
        end
        out
      end
      def get_profile(id)
        opts = {}
        if Slack::API::Auth
          opts['user'] = id
          opts['token'] = Slack::Config.token
          opts['include_labels'] = true
          uri = URI.parse('https://slack.com/api/users.profile.get')
          opts['token'] = Slack::Config.token
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['profile']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def set_profile(opts = {})
        if Slack::API::Auth
          opts['token'] = Slack::Config.token
          uri = URI.parse('https://slack.com/api/users.profile.set')
          opts['token'] = Slack::Config.token
          req = Net::HTTP::Post::Multipart.new(uri.path, opts)
          res = Net::HTTP::new(uri.host, uri.port)
          res.use_ssl = true
          res.verify_mode = OpenSSL::SSL::VERIFY_NONE
          resp = res.start do |http|
            http.request(req)
          end
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['profile']
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
