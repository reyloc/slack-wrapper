# slack-wrapper
Simple Slack API wrapper for ruby

This README is still a work in progress. I will add more to it as time permits.

* [Installation](https://github.com/reyloc/slack-wrapper#installation)
* [Usage](https://github.com/reyloc/slack-wrapper#usage)
  * [Create the bot and get a token](https://github.com/reyloc/slack-wrapper#create-the-bot-and-get-a-token)
  * [Get your user's API token](https://github.com/reyloc/slack-wrapper#get-your-users-api-token)
  * [Using the API token](https://github.com/reyloc/slack-wrapper#using-the-api-token)
  * [Channels](https://github.com/reyloc/slack-wrapper#channels)
    * [Listing all Channels](https://github.com/reyloc/slack-wrapper#listing-all-channels)
    * [Searching Channels](https://github.com/reyloc/slack-wrapper#searching-channels)
    * [Archiving/Creating Channels](https://github.com/reyloc/slack-wrapper#archivingcreating-channels)
    * [Getting Channel Info](https://github.com/reyloc/slack-wrapper#getting-channel-info)
    * [Getting Channel History](https://github.com/reyloc/slack-wrapper#getting-channel-history)
    * [Joining/Leaving a Channel](https://github.com/reyloc/slack-wrapper#joiningleaving-a-channel)
    * [Inviting/Kicking a user to/from a Channel](https://github.com/reyloc/slack-wrapper#invitingkicking-a-user-tofrom-a-channel)
    * [Renaming a Channel](https://github.com/reyloc/slack-wrapper#renaming-a-channel)
    * [Setting Channel Purpose and Topic](https://github.com/reyloc/slack-wrapper#setting-channel-purpose-and-topic)
  * Chat
    * Post Standard Message
    * Post /me Message
    * Post Ephemeral Message
    * Update Message
    * Delete Message
  * [Using RTM](https://github.com/reyloc/slack-wrapper/blob/master/README.md#using-rtm)
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

### Channels

#### Listing all Channels

To get a list of all channels, you will use the ```Slack::API::Channels.get_channels``` function. This takes one option argument to determine if you want archived channels included.

Archive channels excluded:
```
Slack::API::Channels.get_channels
```
Archive channels included:
```
Slack::API::Channels.get_channels(true)
```
The full code would look like this:
```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
channels = Slack::API::Channels.get_channels
```
The return is an array of [channel objects](https://api.slack.com/types/channel) that have been made into Hashes for your convenience. You could use this to then print out all channel names if you so wished:
```
channels.each do |channel|
  puts channel['name']
end
```

#### Searching Channels

To search through all channels, you will use the ```Slack::API::Channels.search``` function. This takes 1 mandatory option and two optional ones:

Option Name | Mandatory?           | Description
------------|----------------------|--------------------------
search      | Yes                  | The search term
archived    | No, default is false | Search archived channels
regex       | No, default is false | Do a regex search

To search for an active channel named 'bacon' we would use coding like:

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
channel = Slack::API::Channels.search('bacon')
```

This will return a [channel object](https://api.slack.com/types/channel) that has been made into Hashes for your convenience. If you did a regex search, you instead get an array of [channel objects](https://api.slack.com/types/channel) that have been made into Hashes for your convenience

#### Archiving/Unarchiving Channels

To archive or unarchive a channel, you will need the Channel ID. This can be obtained via a [channel object](https://api.slack.com/types/channel), such as the one you get from [Searching Channels](https://github.com/reyloc/slack-wrapper#searching-channels). To do this, you will use the ```Slack::API::Channels.archive``` and ```Slack::API::Channels.unarchive``` functions. These take 1 mandatory option (namely the Channel ID):

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
archived = Slack::API::Channels.archive('C516PHW2C')
puts "Channel C516PHW2C archived" if archived
unarchived = Slack::API::Channels.unarchive('C516PHW2C')
puts "Channel C516PHW2C unarchived" if unarchived
```

Both functions return ```true``` or ```false``` to represent if the action succeeded or not. 

#### Creating Channels

To create a channel, you will use the ```Slack::API::Channels.create``` function. This takes 1 mandatory argument (the name of the new channel) and one optional boolean argument. The optional boolean argument tells the Slack API whether it should validate the channel name given or not. What this means is it will change the channel name to meet requirements if needed. By default, this optional argument is set to ```false```.

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
channel = Slack::API::Channels.create('hamsammich')
```

This will return a [channel object](https://api.slack.com/types/channel) that has been made into Hashes for your convenience.

#### Getting Channel Info

To get a [channel object](https://api.slack.com/types/channel) converted into a Hash for your convenience, you will use the ```Slack::API::Channels.info``` function. This function takes 1 mandatory argument (the Channel ID).

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
channel = Slack::API::Channels.info('C516PHW2C')
```

#### Getting Channel History

To get a history of all channel activity, you will use the ```Slack::API::Channels.history``` function. This takes 2 mandatory arguments:

Argument | Meaning                   | Type
---------|---------------------------|--------
id       | The Channel ID            | String
count    | Number of items to return | Integer

Keep in mind the more returned, the longer the query will take. It looks like this:

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
history = Slack::API::Channels.history('C516PHW2C', 100)
```

This will return an array of [message objects](https://api.slack.com/events/message) converted into Hashes for your convenience.

#### Joining/Leaving a Channel

To join a channel, you will use the ```Slack::API::Channels.join``` function, which uses 1 mandatory variable (the channel name). To leave a channel, you instead use the ```Slack::API::Channels.leave``` function, which uses 1 mandatory variable (the channel ID). 

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
puts "Left Channel C516PHW2C" if Slack::API::Channels.leave('C516PHW2C')
puts "Joined Channel bacon" if Slack::API::Channels.join('bacon')
```

Both return a boolean to indicate if the attempted action was successful.

#### Inviting/Kicking a user to/from a Channel

Inviting or kicking a user from a channel will require the User ID and Channel ID. The functions for these are ```Slack::API::Channels.invite_user``` and ```Slack::API::Channels.kick_user``` respectively. They both require 2 mandatory arguments, namely the User ID and Channel ID.

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
puts "Invited User U458DEQKW to Channel C516PHW2C" if Slack::API::Channels.invite_user('U458DEQKW', 'C516PHW2C')
puts "Kick User U458DEQKW from Channnel C516PHW2C" if Slack::API::Channels.kick_user('U458DEQKW', 'C516PHW2C')
```

Both return a boolean to indicate if the attempted action was successful.

#### Renaming a Channel

To rename a channel, you will use the ```Slack::API::Channels.rename``` function. This takes 2 mandatory variables, namely the Channel ID and the new name to use. 

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
puts "Renamed Channel C516PHW2C to pizza" if Slack::API::Channels.rename('C516PHW2C', 'pizza')
```

This returns a boolean to indicate if the attempted action was successful.

#### Setting Channel Purpose and Topic

To set a Channel's purpose or topic, you will use the functions ```Slack::API::Channels.set_pupose``` and ```Slack::API::Channels.set_topic``` respectively. Both take 2 mandatory arguments, namely the Channel ID and the text to use:

```
require 'slack-wrapper'
Slack.configure do |config|
  config.token = 'YOUR TOKEN HERE'
end
puts "Channel C516PHW2C purpose now 'Nomnomnom'" if Slack::API::Channels.set_topic('C516PHW2C', 'Nomnomnom')
puts "Channel C516PHW2C topic now 'Food'" if Slack::API::Channels.set_topic('C516PHW2C', 'Food')
```

Both return a boolean to indicate if the attempted action was successful.

### Chat

#### Post Standard Message

#### Post /me Message

#### Post Ephemeral Message

#### Update Message

#### Delete Message

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
What this will basically do is configure the Slack API token. From there, it will then test if the token is authenticated. If it is, it then generates a websocket URL using the RTM API. It then checks the data coming from the websocket. If the data is a message, it then loops on the entry and checks if the type of message data is a message (meaning someone or something said something in Slack). If it is, it then parses the text of the message. If someone said ```Hello @your_bot``` the bot will post a message saying ```Hello back!``` to the user using ephemeral posting (only that user can see it). Should the text be ```How are you @your_bot?``` the bot will then post a me message (essentially a message prepended with /me) saying it is doing just fine.

## License
This project is licensed under the [MIT License](https://opensource.org/licenses/MIT).
