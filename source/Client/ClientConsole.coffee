Lib = require "../Lib"

module.exports = class extends Lib.Console
	constructor: () ->
		super()
		self = @
		# Echo user input
		# @.on 'input', (msg) ->
		# 	self.ouput_message 'You: ' + msg + "\n"
