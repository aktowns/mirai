class UpdatePlugin < Mirai::Plugin
	def on_register
		add_channel_handler(/update/, :update_handler)
	end
  
	def update_handler(info)
		Mirai::restart()
	end
end