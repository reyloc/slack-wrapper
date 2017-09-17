# https://api.slack.com/methods/files.list
# https://api.slack.com/methods/files.delete
# https://api.slack.com/methods/files.upload
# https://api.slack.com/methods/files.comments.add
# https://api.slack.com/methods/files.comments.delete
# https://api.slack.com/methods/files.comments.edit
# https://api.slack.com/methods/files.revokePublicURL
# https://api.slack.com/methods/files.sharedPublicURL
module Slack
  module API
    module Files
      extend self
      def get_files(type='all')
        if Slack::API::Auth
          type.split(',').each do |t|
            case t
              when 'all', 'spaces', 'snippets', 'images', 'gdocs', 'zips', 'pdfs'
                next
              else
                Slack::Errors.new({'error'  => 'invalid file type',
                                   'detail' => 'Only all, spaces, snippets, images, gdocs, zips, pdfs supported'})
            end
          end
          uri  = URI.parse('https://slack.com/api/files.list')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&types=#{type}")
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['files']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def search(term, regex=false)
        files = get_files
        if regex
          files.select{|f| f['name'] =~ /#{term}/}
        else
          files.select{|f| f['name'] == term}.first
        end
      end
      def delete(id)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/files.delete')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&file=#{id}")
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
      def upload(file, channel, opts={})
        Slack::Errors.new({'error'  => 'file_invalid', 'detail' => 'Object is missing or is not a file'}) unless File.file?(file)
        opts['channels']        = channel
        opts['title']           = File.basename(file) unless opts.has_key? :title
        opts['filename']        = File.basename(file) unless opts.has_key? :filename
        opts['filetype']        = 'auto' unless opts.has_key? :filetype
        opts['initial_comment'] = '' unless opts.has_key? :initial_comment
        if Slack::API::Auth
          uri = URI.parse('https://slack.com/api/files.upload')
          opts['token'] = Slack::Config.token
          File.open(file) do |f|
            opts['file'] = UploadIO.new(f, `file --brief --mime-type #{file}`.strip, opts['filename'])
            req = Net::HTTP::Post::Multipart.new(uri.path, opts)
            res = Net::HTTP::new(uri.host, uri.port)
            res.use_ssl = true
            res.verify_mode = OpenSSL::SSL::VERIFY_NONE
            resp = res.start do |http|
              http.request(req)
            end
            false unless resp.code == 200
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def add_comment(text, file)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/files.comments.add')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&file=#{file}&comment=#{text}")
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['files']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def delete_comment(file, id)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/files.comments.delete')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&file=#{file}&id=#{id}")
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['files']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def edit_comment(text, file, id)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/files.comments.edit')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&comment=#{text}&file=#{file}&id=#{id}")
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['files']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def revoke_URL(file)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/files.sharedPublicURL')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&file=#{file}")
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['file']['url']
          else
            Slack::Errors.new(JSON.parse(resp.body))
          end
        else
          Slack::Errors.new({"error" => "not_authed"})
        end
      end
      def enable_URL(file)
        if Slack::API::Auth
          uri  = URI.parse('https://slack.com/api/files.revokePublicURL')
          http = Net::HTTP.new(uri.host, uri.port)
          http.use_ssl = true
          http.verify_mode = OpenSSL::SSL::VERIFY_NONE
          req  = Net::HTTP::Post.new("#{uri.to_s}?token=#{Slack::Config.token}&file=#{file}")
          resp = http.request(req)
          false unless resp.code == 200
          if JSON.parse(resp.body)['ok']
            JSON.parse(resp.body)['files']
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
