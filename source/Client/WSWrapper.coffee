Emitter = require "events"

# Wrapper for WebSocket to match node-ws' interface
module.exports = class extends Emitter
	constructor: (url) ->
		super()
		@ws = new WebSocket(url)

		self = @
		@ws.onopen = (evt) -> self.emit 'open', evt
		@ws.onclose = (evt) -> self.emit 'close', evt
		@ws.onmessage = (evt) -> self.emit 'message', evt.data
		@ws.onopen = (evt) -> self.emit 'open', evt.data

	send: (message) -> @ws.send message
