module.exports = class

	constructor: (@base) ->
		@available = {}

	add_factory: (type, factory) ->
		@available[type] = factory

	make: (type, options) ->
		if type of @available
			return @available[type].make(@base, options)
		else
			throw new Error "Type '"+type+"' requested but not" +
				" provided by this factory."
