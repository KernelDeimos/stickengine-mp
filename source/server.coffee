uuid = require 'node-uuid'

Resources = require "./Resources"

ServerGame = require "./Server"

Game = class
	constructor: (@name, @instance, @mapname) ->
	add_player: (ws) ->
		self = @
		self.instance.add_player ws
		ws.send JSON.stringify
			type: 'gameon'
			mapname: @mapname

games = []

ServerManager = class
	constructor: (@wss, @logger) ->
	bind: () ->
		self = @
		@wss.on 'connection', (ws) ->
			self.receive_connection ws
	receive_connection: (ws) ->
		self = @

		recvInput = (message) ->
			message = JSON.parse message
			action = message.action

			if action == 'get_servers'
				# Send user a list of "servers"
				serverInfo =
					type: 'serverlist',
					games:
						for game, i in games
							index: i
							name: game.name
							map: game.mapname

				ws.send JSON.stringify serverInfo

				return

			game = null

			if action == 'create'
				# Create a game
				instance = new ServerGame self.logger
				game = new Game message.name, instance, message.mapname
				# Start game
				instance.run();
				# Load the correct map
				mapData = Resources.Maps[message.mapname]
				instance.load_map mapData
				# Register game
				games.push game

				return
			if action == 'join'
				game = games[message.index];

			# Add player to game
			ws.removeListener 'message', recvInput
			game.add_player ws

		ws.on 'message', recvInput

	console.log "TEMPORARY - FOR TESTING"
	# Create a game
	instance = new ServerGame (msg) -> console.log msg
	game = new Game 'Auto Test', instance, 'TestPlatforms'
	# Start game
	instance.run();
	# Load the correct map
	mapData = Resources.Maps['TestPlatforms']
	instance.load_map mapData
	# Register game
	games.push game
			

serverManagerInstance = new ServerManager

module.exports = (wss, logger) ->
	serverManagerInstance = new ServerManager wss, logger
	serverManagerInstance.bind()
