uuid = require 'node-uuid'

module.exports = class
	constructor: () ->
		@subfactories = {}

	register_entity: (type, factory) ->
		@subfactories[type] = factory
		return null

	make: (type, id, props={}) ->
		# If the entity was passed from the server, it has
		# an ID already, but if we're adding a new entity
		# to the server stage it should be generated.
		if not id? then id = uuid.v1()

		# Choose the correct subfactory to make the entity.
		if type of @subfactories
			# Create entity
			fac = @subfactories[type]
			entity = fac.make id, props
			# Return entity
			return entity

		# If no appropriate factory, raise error
		throw new Error "Entity of type '"+type+"' does not exist!"

	deserialize: (data) ->
		console.log "Making a new " + data.type + " from server!"
		entity = @make(data.type, data.uuid, data.props)
		# entity.set_position data.position
		console.log entity
		return entity
