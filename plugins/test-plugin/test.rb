class TestPlugin < Mirai::Plugin
	def on_register
		add_channel_handler(/^\^test/, :test_handler)
	end
	def test_handler(userhash, channel, rest)
		privmsg channel, "Yes #{userhash[:nick]} this is a test."
	end
end