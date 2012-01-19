#!/usr/bin/env ruby

Dir.chdir(File.dirname(__FILE__))

module Mirai
  def self.restart
    output = `git pull`
    puts output
    system "./runbot.rb restart" if (output != "Already up-to-date.\n")
  end
end

if __FILE__ == $0
  Mirai::restart()
end
