module Mirai
	class Plugin
		def initialize config, em, servername, pluginname, handler
			@em, @config, @servername, @pluginname, @handler = em, config, servername, pluginname, handler
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
	end
end