module Mirai
	class Plugin
		def initialize config, em, servername, pluginname, handler
			@em, @config, @servername, @pluginname, @handler = em, config, servername, pluginname, handler
			@trigger = @config.preferredtrigger
		end

		def inspect
			"<##{self.object_id} #{@pluginname} on #{@servername}>"
		end

		private 
		def rawsend raw
			puts "< [#{@pluginname}] #{raw}"
			@em.send_data "#{raw}\r\n"
		end
		def privmsg channel, message
			rawsend "PRIVMSG #{channel} :#{message}"
		end
		def add_channel_handler handler, callback
			@handler.register_channel_handler(handler, self, callback)
		end
		def add_web_handler handler, callback
			@handler.register_web_handler(handler, self, callback)
		end

		def reply message
			privmsg @channel, message
		end

		def mirror_handle to, userhash, channel, matches
			@channel = channel
			userhash[:channel] = channel
			userhash[:raw] = matches[0]
			userhash[:matches] = matches
			send to, userhash, *matches[1..-1]
		end
	end
end