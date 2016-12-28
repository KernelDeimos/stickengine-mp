module.exports = class
	constructor: () ->
		@subfactories = {}
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
