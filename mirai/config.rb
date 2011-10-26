module Mirai
	class Config
		attr_accessor :config

		def initialize file
			raise Errno::ENOENT, "Unable to find the mirai config at #{file}" if !File.exist? file
			@config = File.open(file, 'r') {|fp| YAML::load(fp.read) }
		end

		def config_for server
			@config["Servers"].select{|s| s["Server"] == server}.first
		end

		def value_for forserver, value
			if !forserver.nil? 
				config_for(forserver).nil? ? @config[value] : config_for(forserver)[value]
			else
				@config[value]
			end
		end

		def nick server=nil
			value_for server, "BotNick"
		end

		def user server=nil
			value_for server, "BotUser"
		end

		def fullname server=nil
			value_for server, "BotFullname"
		end

		def password server
			value_for server, "ServerPassword"
		end

		def reconnect server
			val = value_for(server, "ServerReconnect")
			val = true if val.nil?
			val
		end

		def hosts server
			value_for(server, "Hosts").map do |x|
				host, port = x.split(":")
				port = 6667 if port.nil?
				port = port.to_i
				[host, port]
			end
		end

		def channels server
			value_for(server, "Chans").map{|x|"##{x}"}
		end

		def disabled_plugins server
			value_for server, "DisabledPlugins"
		end

		def plugins
			value_for nil, "Plugins"
		end
	end
end