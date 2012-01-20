require 'nokogiri'
require 'open-uri'

class YoutubeurlsPlugin < Mirai::Plugin
	def on_register
		add_channel_handler(/([^\s]*?youtube\.com[^\s]*)/, :youtube_handler, :trigger => :none) # Trigger is assumed as default

	end
  
	def youtube_handler(info, url)
		title = Nokogiri::HTML(open("http://www.youtube.com/watch?v=T-hDt2E8MoE&feature=g-logo&context=G25fb8cbFOAAAAAAAAAA")).title.strip.split("\n").first
		msg info[:chan], "Youtube: #{title}"
	end
end