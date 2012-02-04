require 'nokogiri'
require 'open-uri'

class YoutubeurlsPlugin < Mirai::Plugin
	def on_register
		add_channel_handler(/([^\s]*?youtube\.com[^\s]*)/, :youtube_handler, :trigger => :none) # Trigger is assumed as default

	end
  
	def youtube_handler(info, url)
		title = Nokogiri::HTML(open(url)).title.strip.split("\n").first
		msg info[:chan], "Youtube: #{title}"
	end
end