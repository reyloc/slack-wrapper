# slack-wrapper
Simple Slack API wrapper for ruby

* [Installation](https://github.com/reyloc/slack-wrapper#installation)
* [Usage](https://github.com/reyloc/slack-wrapper#usage)
  * [Create the bot and get a token](https://github.com/reyloc/slack-wrapper#create-the-bot-and-get-a-token)
  * [Get your user's API token](https://github.com/reyloc/slack-wrapper#get-your-users-api-token)
  * [Using the API token](https://github.com/reyloc/slack-wrapper#using-the-api-token)
* [License](https://github.com/reyloc/slack-wrapper#license)
## Installation
You can install the gem via:
```
gem install slack-wrapper
```
If you wish, you could install pull the source code from here and install it locally:
```
git clone git@github.com:reyloc/slack-wrapper.git
cd slack-wrapper
gem build slack-wrapper.gemspec
gem install slack-wrapper-0.0.1.gem
```

## Usage

### Create the bot and get a token
Go to [this link](https://my.slack.com/services/new/bot) to create a new bot.
![Create a Bot Page](images/create_a_bot.png)
From there you will be brought to a page where you can edit the bot name and other such settings. The API key is the important part here, so make sure to copy somewhere safe.

### Get your user's API token
Go to [this link](https://api.slack.com/custom-integrations/legacy-tokens) to get a legacy token (you could go through the whole [Oauth2](https://api.slack.com/docs/oauth) process instead to get a token if you wish). From there, click to get an API token issued and copy it somewhere safe.

### Using the API token
To use your Slack API token, you simply use coding such as this:
```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
```
Replacing YOUR TOKEN HERE with your actual Slack API token.

### Using RTM
This gem includes the two Slack API RTM (real time messaging) functions and can be used for your user/bot to listen and reply  to your slack channels. You can use whatever means you wish to connect and use the websocket link they provide, but my suggestions are [haye-websocket](https://github.com/faye/faye-websocket-ruby) and [EventMachine](https://github.com/eventmachine/eventmachine). Example code of this all in action would be:
```
require 'slack-wrapper'
require 'faye/websocket'
require 'eventmachine'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
if Slack::API::Auth
  wss = Slack::API::RTM.connect
  EM.run do
    ws = Faye::WebSocket::Client.new(wss)
    ws.on :open do |event|
      p [:open]
    end
    ws.on :message do |event|
      data = JSON.parse(event.data)
      if data['type'] == 'message'
        case data['text']
          when "Hello <@#{Slack.id}>"
            Slack::API::Chat.post_ephemeral("Hello back!", data['channel'], data['user'])
          when "How are you <@#{Slack.id}>?"
            Slack::API::Chat.post_me("is doing just fine", data['channel'])
        end
      end
    end
    ws.on :close do |event|
      p [:close, event.code, event.reason]
      ws = nil
    end
  end
end
```
What this will basically do is configure the Slack API token. From there, it will then test if the token is authenticated. If it is, it then generates a websocket URL using the RTM API. It then checks the data coming from the websocket. If the data is a message, it then loops on the entry and checks if the type of message data is a message (meaning someone or something said something in Slack). If it is, it then parses the text of the message. If someone said ```Hello @your_bot``` the bot will post a message saying ```Hello back!``` to the user using emphemeral posting (only that user can see it). Should the text be ```How are you @your_bot?``` the bot will then post a me message (essentially a message prepended with /me) saying it is doing just fine.

## License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
