Mirai  
================
![](http://i.imgur.com/vyS0s.png)  

## About
Mirai is yet another ruby irc bot, focused on plugins supplying features over core features in the bot for example the only commands the bot provides without plugins are `about-plugin` and `help [plugin]`.  

Mirai is written using the wonderful [EventMachine](http://rubyeventmachine.com/) library, and uses [yaml](http://yaml.org/start.html) for configuration and [sqlite](https://github.com/luislavena/sqlite3-ruby) for storage and [daemons](http://daemons.rubyforge.org/) for background processing the builtin webserver is based on [thin](http://code.macournoyer.com/thin/). plugins may contain additional dependencies. 

## Why?
Because I can!, and have different ideas on what a good bot should look like. 

## How?
After editing the config file (below) run `./runbot start` or to not background the process `./runbot start --ontop` 


## Configuration

### Dependencies
To install the rubygem dependencies simply run `bundle install` in the root of the repo.  
Mirai should run on ruby 1.9.3.

### config.yml
Mirai uses yaml for all configurations, to setup the bot you will need to open `config.yml` in your favourite editor.
When writing plugins you will need to supply a `plugin-name.yml` file, check writing plugins below for more information.

*TODO: expand on config*

## Writing Plugins
Plugins are subclasses of the `Miraii::Plugin` class and provide a few helper functions to get you started.  
Firstly, lets create a hello world plugin.

### Hello World
The folder structure should look similar to the following:  
mirai   
-> plugins    
--> helloworld-plugin  
---> helloworld-plugin.yml  
---> helloworld.rb  

`helloworld-plugin.yml` should consist of:  

~~~~~ yaml
Name: Helloworld
Author: Your name <you@email.com>
Version: 0.0.1
Type: Channel
Files: [ helloworld.rb ]
~~~~~

`helloworld.rb` should consist of:  

~~~~~ ruby
class HelloworldPlugin < Mirai::Plugin
	def on_register															# Called when the plugin is initialized
		add_channel_handler(/talktome (.*)$/, :test_handler) 			# ^talktome
		add_web_handler(/helloworld/, :test_web_handler) 				# http://0.0.0.0:3000/helloworld
	end

	def test_handler(info, what)
		privmsg info[:chan], "Well, Hello World! #{info[:nick]}. I don't know what #{what} is!"
	end

	def test_web_handler(env)
		privmsg "#achannel", "Hello world from the web!"
		"OK" 																# return text "OK" to the webrequest
	end
end
~~~~~

*TODO: expand on plugins more*

### Builtin Webserver
Mirai contains a built in webserver in order to write plugins for callbacks from webservices (github for instance)

*TODO: expand expand*

## Updates

*TODO: self update plugin*
*TODO: plugin auto updates*

## Todo

*TODO: todo*