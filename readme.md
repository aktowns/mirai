Mirai  
================
![](http://i.imgur.com/vyS0s.png)  

## About
Mirai is yet another ruby irc bot, focused on plugins supplying features over core features in the bot for example the only commands the bot provides without plugins are `about-plugin` and `help [plugin]`.  

Mirai is written using the wonderful [EventMachine]() library, and uses [yaml]() for configuration and [sqlite]() for storage and [daemons]() for background processing the builtin webserver is based on [thin](). plugins may contain additional dependencies. 

## Why?
Because i can!, and have different ideas on what a good bot should look like. 

## Configuration

### Dependencies
To install the rubygem dependencies simply run `bundle install` in the root of the repo.  
Mirai should run on MRI 1.8.7, 1.9.2 and jruby.

### config.yml
Mirai uses yaml for all configurations, to setup the bot you will need to open `config.yml` in your favourite editor.
When writing plugins you will need to supply a `plugin-name.yml` file, check writing plugins below for more information.

*TODO:* expand on config

## Writing Plugins
Plugins are subclasses of the `Miraii::Plugin` class and provide a few helper functions to get you started.  
Firstly, lets create a hello world plugin.
### Hello World
The folder structure should look similar to the following:  
mirai   
->plugins    
-->helloworld-plugin  
--->helloworld-plugin.yml  
--->helloworld.rb  

helloworld-plugin.yml should consist of:
    dd  
    ee
helloworld.rb should consist of:


### Builtin Webserver

## Updates

## Security
### Security is a lie
## Todo

