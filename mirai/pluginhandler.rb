require 'yaml'

module Mirai
	class PluginHandler
		attr_reader :plugins

		def initialize config, servername, em, core
			@config, @servername, @em, @core = config, servername, em, core
			@plugins = {}
			@config.plugins.each do |plugin|
				next if plugin["Update"] != "core"
				name = plugin["Plugin"]
				metadatalocation = "plugins/#{name}/"
				throw "Plugin #{name} does not exist in #{metadatalocation}/#{name}.yml" if !File.exist?("#{metadatalocation}/#{name}.yml")

				pluginmeta = File.open("#{metadatalocation}/#{name}.yml", 'r') {|fp| YAML::load(fp.read) }
				pluginmeta["Files"].each do |file|
					require_relative "../#{metadatalocation}/#{file}"
				end
				pluginklass = Object.const_get("#{pluginmeta["Name"]}Plugin").new config, em, servername, pluginmeta["Name"], self
				@plugins[name] = {:pluginklass => pluginklass, :meta => pluginmeta, :conf => plugin}
				pluginklass.on_register
			end
		end

		def register_channel_handler handler, object, callback
			name = @plugins.find{|x,y| y[:pluginklass] == object }.first
			puts "Registering handler for #{name}."
			@core.register_channel_handler(handler, object, callback)
		end

		def register_web_handler handler, object, callback
			name = @plugins.find{|x,y| y[:pluginklass] == object }.first
			puts "Registering handler for #{name}."
			@core.register_web_handler(handler, object, callback)
		end
	end
end