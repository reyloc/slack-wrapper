module Slack
  module API
    module Auth
      extend self
      def is_valid?
        case Slack::Config.token
          when nil
            false
          when String
            uri  = URI.parse('https://slack.com/api/auth.test')
            http = Net::HTTP.new(uri.host, uri.port)
            http.use_ssl = true
            http.verify_mode = OpenSSL::SSL::VERIFY_NONE
            req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}")
            resp = http.request(req)
            false unless resp.code == 200
            JSON.parse(resp.body)['ok']
          else
            false
        end
      end
      def whoami
        uri  = URI.parse('https://slack.com/api/auth.test')
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE
        req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}")
        resp = http.request(req)
        false unless resp.code == 200
        data = JSON.parse(resp.body)
        return {"name" => data['user'], 'id' => data['user_id']}
      end
      is_valid?
    end
  end
end
