class RegexPlugin < Mirai::Plugin
	def on_register
		@buffer = []
		add_channel_handler(/s\/(.*)([^\\\/]*\/)(.*)([^\\\/]*\/)$/, :regex_handler, :trigger => :none)
		add_channel_handler(/(?!^s\/)(.*)$/, :buffer_handler, :trigger => :none)
	end
  
	def buffer_handler info, all
		@buffer << {:nick => info[:nick], :message => all, :channel => info[:channel]}
		@buffer = @buffer[@buffer.length-50..-1] if @buffer.length > 50
	end
  
	def regex_handler info, one, two, three, four
		targetline = @buffer.reverse.find {|line| line[:message].match(/#{one}/) && line[:channel] == info[:channel] }
		return if targetline.nil?
		targetline[:message].gsub!(/#{one}/, three)
		reply "<#{targetline[:nick]}> #{targetline[:message]}"
	end
end