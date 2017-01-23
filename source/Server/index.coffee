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

console.log "TODO: Server shouldn't send platforms"

module.exports = class
	constructor: (@logger) ->
		@emitter = new Emitter

	run: () ->
		@players = [] # player objects with methods

		# === Build Engines ===
		physics = new Game.Engines.Physics

		# === Build Game ===
		builder = new GameBuilder
		@game = builder.build
			env: Game.Context.ENV_SERVER

		@game.add_engine physics

		builder.install_all_modules @game

		@loader = new Game.MapLoader
		@game.install_module @loader

		self = @
		# setInterval () ->
		# 	for i in [1..5]
		# 		self.stage.add_entity self.entities.make 'fragment'
		# , 60000

		@_push()

	load_map: (mapData) ->
		@loader.load_map mapData

	process_input: (input) ->
		self = @
		if input is 'test'
			for i in [1..10]
				self.game.add_entity 'crate'
			return
		@logger "The server is not currently configured " +
			"to process the command \""+input+"\""

	# Listens to incoming connections
	add_player: (ws, meta) ->
		@logger "New Player!"
		@_add_new_player ws, meta

	# Pushes updates to players
	_push: () ->
		self = @

		# Engine to update user with stage events
		@game.add_engine new (class
			activate: (context, stage) -> stage.on \
				'stage.rem_entity', (entity) ->
					for player in self.players
						# Send serialized data
						try
							player.send
								type: 'remove',
								uuid: entity.uuid

						catch err
							# Remove player
							self.players = \
								self.players.filter (p) -> p isnt player
		)

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

			if message.charAt(0) == '/'
				console.log "TODO: Verify player permissions"
				console.log "TODO: Modularize command system"
				if message == '/crates'
					for i in [1..20]
						crate = self.game.add_entity 'crate'
				if message == '/stres'
					for i in [1..100]
						crate = self.game.add_entity 'crate'

			# for recipient in self.players
			# 	recipient.send
			# 		type: 'chat',
			# 		message: message
			self._send_message_to_chat message, player

		@emitter.on 'player.new', (newPlayer) ->
			datum = newPlayer.serialize()

			for player in self.players
				player.send \
					type: 'player.new',
					datum: datum

	_send_message_to_chat: (text, player) ->
		for recipient in @.players
			recipient.send (
				if player?
					type: 'chat',
					uuid: player.get_id()
					message: text
				else
					type: 'chat',
					message: text
			)

	_add_new_player: (ws, meta) ->

		self = @

		receiveFirstMessage = (message) ->
			# Remove this listener
			self.logger "First Message"
			ws.removeListener 'message', receiveFirstMessage

			# Create an entity for this player
			playerEntity = self.game.add_entity 'stickhuman'
			playerEntity.set_position 100, 0

			# Create player record
			player = new Player ws, playerEntity, meta

			# Ensure removal of player & entity on disconnect
			ws.on 'close', () ->
				# Remove entity
				self.game.rem_entity playerEntity

				# Remove player
				self.players = \
					self.players.filter (p) -> p isnt player

				self._send_message_to_chat 'Player disconnect: '+
					meta.name

			# Send initial data to player
			okayMessage =
				'type': 'initialize'
				# :: send entity id of player's entity
				'entity_id': playerEntity.get_id()
				# :: send meta data of players
				'players': self._get_players_meta_object player
				# :: <send created entities>
				# TODO: separate creation from update

			ws.send JSON.stringify okayMessage

			# Tell other players about new player
			self.emitter.emit 'player.new', player

			# Wait a bit
			setTimeout ()->				

				# Add player to listeners list
				self.players.push player
				# Listen to player
				player.listen(self.emitter)

			, 100

		ws.on 'message', receiveFirstMessage

	_get_players_meta_object: (additionalPlayer = null) ->
		result = (
			for player in @.players
				player.serialize()
		)
		if additionalPlayer?
			result.push additionalPlayer.serialize()
		return result
