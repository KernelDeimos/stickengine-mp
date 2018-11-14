domready = require "domready"
Emitter = require "events"
WebSocket = require "./Client/WSWrapper"

Resources = require "./Resources"

Client = require "./Client"

# require "./polyfills"

class Menu extends Emitter
	constructor: (@menu) ->
		super()

class Term extends Emitter
	constructor: (@menu) ->
		super()


domready(
	() ->
		canvas = document.getElementById('tester')
		menuEl = document.getElementById('menu')

		window.menu = menu = new Menu menuEl
		window.term = term = new Term

		ws = null

		menu.on 'do', (data) ->
				console.log 'Outgoing:'
				console.log data
				ws.send JSON.stringify data

		menu.on 'ready', () ->

			console.log 'client menu ready'

			# Connect to server
			ws = new WebSocket 'ws://'+window.location.hostname+':8232';

			ws.on 'open', () ->
				menu.emit 'connected'

			ws.on 'message', (message) ->
				message = JSON.parse message

				console.log 'Incoming:'
				console.log message

				# Server sends this after a server list was requested
				if message.type == "serverlist"
					menu.emit 'serverlist', message.games
					return

				# Server sends this when the player joins a game
				if message.type == "gameon"
					# Update menu (menu will hide)
					menu.emit 'gameon'
					# Stop listening to server (this is the clients job)
					# Note: in the future, a new websocket will be
					#       provided by the server
					ws.removeAllListeners();
					# Start client
					client = new Client canvas, ws
					client.start()
					window.game = client
					term.emit 'new_game', client.get_console(), client
					# Load a map
					mapData = Resources.Maps[message.mapname]
					# console.log mapData
					client.load_map mapData
					# Send first message
					ws.send 'ready'

		# game = new Client canvas, ws

		# expose game for console debugging
		# window.game = game

		# setTimeout () ->
			# window.on_game_ready()
		# , 10

		# game.start()
		# game.do_test()
)
