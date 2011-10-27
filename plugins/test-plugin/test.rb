class TestPlugin < Mirai::Plugin
	def on_register
		add_channel_handler(/^#{@trigger}test/, :test_handler)
		add_web_handler(/^\/testing/, :test_web_handler)
	end
	def test_handler(userhash, channel, matches)
		privmsg channel, "Yes #{userhash[:nick]} this is a test."
	end

	def test_web_handler(env)
		privmsg "#main", "User has hit http://0.0.0.0/testing"
		"OK"
	end
end