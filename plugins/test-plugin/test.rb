class TestPlugin < Mirai::Plugin
	def on_register
		add_channel_handler(/test/, :test_handler) # Trigger is assumed as default
		add_channel_handler(/crash/, :crash_handler)
		add_web_handler(/testing/, :test_web_handler)
	end
  
	def test_handler(info)
		msg info[:chan], "Yes #{info[:nick]} this is a test."
		me info[:chan], "thrusts"
	end

	def test_web_handler(env)
		privmsg "#main", "User has hit http://0.0.0.0/testing"
		"OK"
	end

	def crash_handler(info)
		msg info[:chan], "Forcing plugin to crash"
		bob!
	end
end