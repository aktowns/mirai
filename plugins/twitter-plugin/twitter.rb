# encoding: UTF-8
require 'twitter'

class TwitterPlugin < Mirai::Plugin
  def on_register
    add_channel_handler(/https?:\/\/twitter.com\/.*\/statuse?s?\/([0-9]{0,20})/, :tweet_handler, :trigger => :none)
  end

  def tweet_handler info, id
    begin
      t = Twitter.status id
      screen_name, name, text = t.user.screen_name, t.user.name, t.text
      action info[:chan], "@#{screen_name} (#{name}) => #{text}"
    rescue Twitter::Error::Forbidden
      msg info[:chan], "This tweet is private"
    rescue Twitter::Error::NotFound
      msg info[:chan], "No tweet with that ID"
    end
  end
end