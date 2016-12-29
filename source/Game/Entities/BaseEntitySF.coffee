Context = require "../Context"

# Base class for entity subfactory
module.exports = class
	# @param [Object] context  contains information about the running instance
	# @option context [Number] env  constant of Context for environment
	constructor: (@context) ->

	# @param [String] id  a valid uuid
	# param [Object] params  an object describing entity properties
	make: (id, props) ->
		if @context.env == Context.ENV_SERVER
			@make_server(id, props)
		if @context.env == Context.ENV_CLIENT
			@make_client(id, props)

	make_client: (id, props) -> throw new Error "No implementation for make_client"
	make_server: (id, props) -> throw new Error "No implementation for make_server"
