require 'thin'

module Mirai
	class WebServer
		def initialize
			@handlers = []
		end

		def add_web_handler(handler, object, callback) 
			@handlers << {:handler => handler, :obj => object, :callback => callback}
		end

		def call(env)
			response = nil
			@handlers.each do |h|
				p env["REQUEST_PATH"]
				p h[:handler]
				if env["REQUEST_PATH"].match(h[:handler])
					response = h[:obj].send(h[:callback], env)
					break
				end
			end
			if response.nil?
				[
					404,
					{ 'Content-type' => 'text/plain' },
					['This is not the server you\'re looking for']
				] 
			else
				response
			end
		end
	end
end