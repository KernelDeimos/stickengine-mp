domready = require "domready"
WebSocket = require "./Client/WSWrapper"

Client = require "./Client"

domready(
	() ->
		canvas = document.getElementById('tester')

		# Connect to server
		ws = new WebSocket 'ws://127.0.0.1:8232'

		game = new Client canvas, ws

		# expose game for console debugging
		window.game = game

		setTimeout () ->
			window.on_game_ready()
		, 10

		game.start()
		game.do_test()
)
