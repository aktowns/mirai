module Mirai
	class Core
		def initialize config, servername, eventmachine, webserver
			@config, @servername, @em, @webserver = config, servername, eventmachine, webserver
			@handlers = {}
			puts "Core initialized for #{servername}"
		end

		def on_connect
			rawsend "PASS #{@config.password(@servername)}" if !@config.password(@servername).nil?
			rawsend "NICK #{@config.nick}"
			rawsend "USER #{@config.user} mirai * 0 :#{@config.fullname}"
		end

		def on_data data
			puts "> #{data}"
			rgxUser = /^:([^\x07\x2C\s]+?)!([^\x07\x2C\s]+?)@([^\x07\x2C\s]+?)\s(.*)$/
			rgxServer = /^:([^\x07\x2C\s]+?)\s(.*)$/
			rgxCmd = /^([^:\x07\x2C\s]+?)\s:(.*)$/
		
			rgxChannelMessage = /^PRIVMSG [#&]([^\x07\x2C\s]+?) :(.*)$/
			rgxUserMessage = /^PRIVMSG ([^#&\x07\x2C\s]+?) :(.*)$/
			rgxNumeric= /^([0-9]{3}) ([^\x07\x2C\s]+?) (.*)$/ 

			if data.match(rgxUser)
				nick, ident, host, rest = $1, $2, $3, $4.strip
				puts "user"
				if rest.match(rgxChannelMessage)
					channel, message = "##{$1}", $2
					userhash = {
						:nick => nick,
						:ident => ident,
						:host => host
					}
					on_channelmessage(userhash, channel, message)
				elsif rest.match(rgxUserMessage)
					target, message = $1, $2
					userhash = {
						:nick => nick,
						:ident => ident,
						:host => host
					}
					on_usermessage(userhash, target, message)
				else

				end
			elsif data.match(rgxServer)
				server, rest = $1, $2.strip
				if rest.match(rgxNumeric)
					numeric, target, message = $1, $2, $3

					case numeric.to_i
					when 376 then @config.channels(@servername).each{|c| do_join(c) }
					when 433 then do_nick(@config.config["BotNick"] += "_")
					end
				end
				
			elsif data.match(rgxCmd)
				command, rest = $1, $2.strip
				do_pong rest if command.downcase == "ping"
			else
				throw "Unknown irc response: #{data}"
			end
		end

		def register_channel_handler handler, object, method 
			@handlers[handler] = {:obj => object, :method => method}
		end

		def unregister_channel_handler handler

		end

		def register_web_handler handler, object, method
			@webserver.add_web_handler(handler, object, method)
		end

		def unregister_web_handler handler

		end

		private
		def rawsend data
			@em.send_data data + "\r\n"
			puts "< #{data}"
		end

		def privmsg target, message
			rawsend "PRIVMSG #{target} :#{message}"
		end

		def on_channelmessage userhash, channel, message
			puts "#{userhash[:nick]}->#{channel} >> #{message}"
			@handlers.each do |handle, val|
				if (message.match(handle))
					val[:obj].send(val[:method], userhash, channel, message.match(handle))
				end
			end
		end

		def on_usermessage userhash, target, message

		end

		def do_pong ping
			puts "Ping, Pong"
			rawsend "PONG #{ping}"
		end

		def do_join channel, pass=nil
			puts "Joining #{channel}"
			rawsend "JOIN #{channel} #{pass}"
		end

		def do_nick newnick
			puts "Changing nick to #{newnick}"
			rawsend "NICK #{newnick}"
		end
	end
end