Emitter = require "events"

# Generic class for a console
module.exports = class extends Emitter
	enter_command: (message) ->
		@.emit('input', message)
	ouput_message: (message) ->
		@.emit('ouput', message)
