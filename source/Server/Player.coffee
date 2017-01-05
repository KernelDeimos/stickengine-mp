Game = require "../Game"

# Represents a player in a server instance
module.exports = class
	constructor: (@ws, @entity, @playerMeta) ->
		@controller = new Game.Misc.CreatureController @entity

	# Send data through player's websocket
	#
	# @param [Object] message  an object
	# @option message [String] type  type of message
	send: (message) ->
		@ws.send JSON.stringify message

	# --- Specialized Send Functions --- #

	# Sends an update of entity data to the player
	#
	# @param [Array] data  list of serialized entities
	send_update: (data) ->
		message =
			type: 'update',
			data: data
		@send message

	listen: (emitter) ->
		self = @
		@ws.on 'message', (message) ->
			message = JSON.parse message

			# Updates
			if message.type == 'update'
				self.controller.update_control \
					message.control, message.state

			if message.type == 'chat'
				msg = message.message
				# usr = self.playerMeta.name
				# fulltext = usr + ': ' + msg;
				# emitter.emit 'player.chat', self, msg, fulltext
				emitter.emit 'player.chat', self, msg

	get_id: () -> @.entity.get_id()

	# Returns meta information that should be shared
	# with other player's clients.
	serialize: () ->
		name: @playerMeta.name
		uuid: @entity.get_id()
