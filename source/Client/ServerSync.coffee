Lib = require "../Lib"

# This class updates the client's stage when the
# server sends new information

module.exports = class
	# Constructs the updater
	#
	# @param ws an established websocket connection
	# @entities entity factory
	# @stage the stage for the current game instance
	constructor: (@ws, @player, @userconsole, @keyboard) ->
		@playerEntityID = null

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
			self.playerEntityID = data.entity_id
			self.player.set_id data.entity_id

			console.log "Received ID from server: " + data.entity_id

			# Start Listeners / Updaters
			self._push_player_actions self.keyboard
			self._push_player_messages @userconsole
			self._listen()

		@ws.on 'message', receiveInitialize

		@ws.on 'open', () ->
			# Say hello to the server (to get initialization data)
			self.ws.send 'hello!'

	_push_player_actions: () ->

		self = @

		self.keyboard.on 'any', (control, state) ->
			updateMessage =
				type: 'update'
				control: control
				state: state
			self.ws.send JSON.stringify updateMessage

	_push_player_messages: () ->
		self = @

		self.userconsole.on 'input', (message) ->
			if message[0] != '/'
				self.ws.send JSON.stringify
					type: 'chat',
					message: message

	_listen: () ->
		self = @

		@ws.on 'message', (message) ->
			message = JSON.parse message
			if message.type == 'update'

				for datum in message.data
					entity = self.stage.get_entity_by_id datum.uuid
					if not entity?
						entity = self.entities.deserialize datum
						self.stage.add_entity entity
					else
						# if entity.get_id() isnt self.playerEntityID
							# entity.set_position datum.position
						body = entity.get_body()
						dat  = datum.body_data
						Lib.Body.update_from_serialized_data body, dat

			else if message.type == 'chat'
				self.userconsole.ouput_message \
				message.message + "\n"
			else
				console.log "Unrecognized message"


	# Returns UUID for the player's entity given by the server.
	get_player_id: () -> @playerEntityID
