Matter = require "matter-js"
Emitter = require "events"

# Libraries and Game
Lib = require "../Lib"
Game = require "../Game"
GameBuilder = require "../GameBuilder"

# Server Only
Player = require "./Player"

# Factories
Entities = Game.Entities

module.exports = class
	constructor: (@wss, @logger) ->
		@emitter = new Emitter

	run: () ->
		@players = []

		# === Build Engines ===
		physics = new Game.Engines.Physics

		# === Build Game ===
		builder = new GameBuilder
		@game = builder.build
			env: Game.Context.ENV_SERVER

		@game.add_engine physics

		builder.install_all_modules @game

		# === Testing ===
		@game.add_entity 'platform',
			x: 400
			y: 600
			w: 800
			h: 20

		@game.add_entity 'crate'

		self = @
		# setInterval () ->
		# 	for i in [1..5]
		# 		self.stage.add_entity self.entities.make 'fragment'
		# , 60000

		@_listen()

		@_push()

	process_input: (input) ->
		self = @
		if input is 'test'
			for i in [1..10]
				self.game.add_entity 'crate'
			return
		@logger "The server is not currently configured " +
			"to process the command \""+input+"\""

	# Listens to incoming connections
	_listen: () ->
		self = @
		@wss.on 'connection', (ws) ->
			self.logger "New Connection!"
			self._add_new_player ws

	# Pushes updates to players
	_push: () ->
		self = @

		# Push new positions at regular interval
		setInterval () ->
			# Fetch entities from stage and serialize them
			entities = self.game.get_entities()
			data = (
				for entity in entities
					# TODO: replace with serialize_update
					# once the client can request additional info
					entity.serialize()
			)

			# Iterate over all players
			for player in self.players
				# Send serialized data
				try
					player.send_update data
				catch err
					# Remove player
					self.players = \
						self.players.filter (p) -> p isnt player

			return # don't return anything

		, 20

		@emitter.on 'player.chat', (player, message) ->
			console.log message
			for recipient in self.players
				recipient.send
					type: 'chat',
					message: message

	_add_new_player: (ws) ->

		self = @

		receiveFirstMessage = (message) ->
			# Remove this listener
			self.logger "First Message"
			ws.removeListener 'message', receiveFirstMessage

			# Create an entity for this player
			playerEntity = self.game.add_entity 'crate'
			playerEntity.set_position 100, 0

			# Create player record
			player = new Player ws, playerEntity

			# Sent player the "okay, you're in" message
			okayMessage =
				'type': 'initialize'
				# send entity id so the player can ignore
				# creation of its own entity
				'entity_id': playerEntity.get_id()

			ws.send JSON.stringify okayMessage

			# Add player to listeners list
			self.players.push player
			# Listen to player
			player.listen(self.emitter)

		ws.on 'message', receiveFirstMessage
