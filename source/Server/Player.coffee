Game = require "../Game"

# Represents a player in a server instance
module.exports = class
	constructor: (@ws, @entity) ->
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
				msg = \
				'['+self.entity.get_id().substring(0,6)+'] '+ msg
				emitter.emit('player.chat', self, msg)
