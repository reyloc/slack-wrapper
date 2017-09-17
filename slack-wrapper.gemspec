Gem::Specification.new do |s|
  s.name        = 'slack-wrapper'
  s.version     = '0.0.1'
  s.date        = '2017-09-18'
  s.summary     = "TBD"
  s.description = 'Simple Slack API wrapper for ruby'
  s.authors     = ['Jason Colyer']
  s.email       = 'jcolyer2007@gmail.com'
  s.homepage    = 'https://rubygems.org/gems/slack-ruby'
  s.license     = 'MIT'
  s.files       = ['lib/slack-wrapper.rb',
                   'lib/slack-wrapper/errors.rb',
                   'lib/slack-wrapper/config.rb',
                   'lib/slack-wrapper/api/users.rb',
                   'lib/slack-wrapper/api/rtm.rb',
                   'lib/slack-wrapper/api.rb',
                   'lib/slack-wrapper/api/permissions.rb',
                   'lib/slack-wrapper/api/im.rb',
                   'lib/slack-wrapper/api/files.rb',
                   'lib/slack-wrapper/api/chat.rb',
                   'lib/slack-wrapper/api/channels.rb',
                   'lib/slack-wrapper/api/bots.rb',
                   'lib/slack-wrapper/api/auth.rb'
                 ]
  s.add_runtime_dependency 'net/https', '~> 0'
  s.add_runtime_dependency 'json', '~> 0'
  s.add_runtime_dependency 'uri', '~> 0',
  s.add_runtime_dependency 'iodine', '~> 0'
  s.add_runtime_dependency 'multipart-post', '~> 0'
end
