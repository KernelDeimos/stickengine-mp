Lib = require "../Lib"

# Private class for player information
class Player
	constructor: (meta, @userconsole, @stage) ->
		# name, uuid
		@name = meta.name
		@uuid = meta.uuid
	say: (text) ->
		console.log 'text'
		# Update talk bubble above entity
		entity = @stage.get_entity_by_id @uuid
		if entity == null then return
		entity.say text
		# Output some text to the console
		text = @name + ': ' + text;
		@userconsole.ouput_message text + "\n"

# This class updates the client's stage when the
# server sends new information

module.exports = class
	# Constructs the updater
	#
	# @param ws an established websocket connection
	# @entities entity factory
	# @stage the stage for the current game instance
	constructor: (@ws, @player, @userconsole, @keyboard, @mouse) ->
		@playerEntityID = null
		@players = {} # player data objects; TODO: change

	install: (base) ->
		@context = base.context
		@stage = base.stage
		@entities = base.entities

	# Activates the updater by obtaining initialization
	# information from the server and starting socket
	# listeners.
	activate: () ->
		self = @

		# This is required for relative position updates.
		# This will usually be the last value that was
		# received from the server.
		@lastPosition = @player.get_position()

		# Listen for first message (initialization data)
		receiveInitialize = (data) ->
			data = JSON.parse data
			console.log "Received data from server! Yay!"
			# Remove this listener
			self.ws.removeListener 'message', receiveInitialize

			# Initialize
			# :: set player id
			self.playerEntityID = data.entity_id
			self.player.set_id data.entity_id
			# :: set data objects for players
			for plyr in data.players
				self._add_player plyr

			console.log "Received ID from server: " + data.entity_id

			# Start Listeners / Updaters
			self._push_player_actions self.keyboard
			self._push_player_messages @userconsole
			self._listen()

		@ws.on 'message', receiveInitialize

		@ws.on 'open', () ->
			# Say hello to the server (to get initialization data)
			self.ws.send 'hello!'

	_add_player: (data) ->
		key = data.uuid
		@players[key] = new Player \
			data, @userconsole, @stage
		# set nametag on entity
		self = @
		setTimeout () ->
			entity = self.stage.get_entity_by_id key
			entity.set_name data.name
		, 300

	_push_player_actions: () ->

		self = @

		self.keyboard.on 'any', (control, state) ->
			updateMessage =
				type: 'update'
				control: control
				state: state
			self.ws.send JSON.stringify updateMessage

		setInterval () ->
			# Get player angle
			angle = self.player.get_angle()
			# Send server an update with the angle
			updateMessage =
				type: 'mouse',
				angle: angle
			self.ws.send JSON.stringify updateMessage
		, 30

	_push_player_messages: () ->
		self = @

		self.userconsole.on 'input', (message) ->
			# if message[0] != '/'
			self.ws.send JSON.stringify
				type: 'chat',
				message: message

	_listen: () ->
		self = @

		@ws.on 'message', (message) ->
			message = JSON.parse message

			# Receive update for entity states
			if message.type == 'update'

				for datum in message.data
					entity = self.stage.get_entity_by_id datum.uuid
					if not entity?
						entity = self.entities.deserialize datum
						self.stage.add_entity entity
					else
						entity.deserialize_update datum

			else if message.type == 'remove'
				entity = self.stage.get_entity_by_id message.uuid
				self.stage.rem_entity entity

			# <Receive new entities >
			# TODO: Implement on server

			# Receive new players
			else if message.type == 'player.new'
				self._add_player message.datum

			# Receive chat messages
			else if message.type == 'chat'
				# Check if player message
				if message.uuid?
					console.log self.players
					console.log message.uuid
					# Check if player is available
					if message.uuid of self.players
						# p is the player
						p = self.players[message.uuid]
						p.say message.message
						# player will add message to console
						return
				# Add message to console
				self.userconsole.ouput_message \
				message.message + "\n"
			else
				console.log "Unrecognized message"


	# Returns UUID for the player's entity given by the server.
	get_player_id: () -> @playerEntityID
