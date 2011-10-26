class RegexPlugin < Mirai::Plugin
	def on_register
		@buffer = []
		add_channel_handler(/^s\/(.*)([^\\\/]*\/)(.*)([^\\\/]*\/)$/, :regex_handler)
		add_channel_handler(/^(?!^s\/)(.*)$/, :buffer_handler)
	end
	def buffer_handler userhash, channel, matches
		@buffer << {:nick => userhash[:nick], :message => matches[1], :channel => channel}
		@buffer = @buffer[@buffer.length-50..-1] if @buffer.length > 50
	end
	def regex_handler userhash, channel, matches
		targetline = @buffer.reverse.find {|line| line[:message].match(/#{matches[1]}/) && line[:channel] == channel }
		return if targetline.nil?
		targetline[:message].gsub!(/#{matches[1]}/, matches[3])
		privmsg channel, "<#{targetline[:nick]}> #{targetline[:message]}"
	end
end