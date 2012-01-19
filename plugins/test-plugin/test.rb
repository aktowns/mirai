class TestPlugin < Mirai::Plugin
	def on_register
		add_channel_handler(/test/, :test_handler) # Trigger is assumed as default
		add_web_handler(/testing/, :test_web_handler)
	end
  
	def test_handler(info)
		msg info[:chan], "Yes #{info[:nick]} this is a test."
	end

	def test_web_handler(env)
		privmsg "#main", "User has hit http://0.0.0.0/testing"
		"OK"
	end
end