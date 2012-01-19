#!/usr/bin/env ruby

Dir.chdir(File.dirname(__FILE__))

output = `git pull`
puts output
system "./runbot.rb restart" if (output != "Already up-to-date.\n")
