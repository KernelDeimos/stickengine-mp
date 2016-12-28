 
 
Matter = require "matter-js"
Emitter = require "events"

Lib = require "../Lib"

Game = require "../Game"

Physics = Game.Physics
Stage = Game.Stage

# Factories
Entities = Game.Entities

module.exports = class
	constructor: (@wss, @logger) ->

	run: () ->

		@players = []

		# Construct stage and event emitter
		@emitter = new Emitter
		@stage = new Stage @emitter

		# Instanciate and activate physics controller
		physics = new Physics @emitter, @stage
		physics.activate_servermode()

		# Also we need an instance of the entities factory
		@entities = new Entities

		@stage.add_platform @entities.make_platform \
			400, 600, 800, 20

		@stage.add_platform @entities.make_platform \
			5, 300, 10, 580
		@stage.add_platform @entities.make_platform \
			795, 300, 10, 580

		self = @
		# setInterval () ->
		# 	for i in [1..5]
		# 		self.stage.add_entity self.entities.make 'fragment'
		# , 60000

		@_listen()

		@_push()

	process_input: (input) ->
		self = @
		if input is 'add5'
			for i in [1..5]
				self.stage.add_entity self.entities.make 'fragment'
			return
		if input is 'add10'
			for i in [1..10]
				self.stage.add_entity self.entities.make 'fragment'
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
			entities = self.stage.get_entities()
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

		# Push events
		@emitter.on 'stage.add_entity', (entity) ->
			# Send entity to client

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
			playerEntity = self.entities.make 'launcher'
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
			# Add player entitiy to stage
			self.stage.add_entity playerEntity

		ws.on 'message', receiveFirstMessage
