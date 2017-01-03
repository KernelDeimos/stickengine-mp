module.exports = class

	constructor: () ->
		@available = {}

	add_factory: (type, factory) ->
		@available[type] = factory

	make: (type, options) ->
		if type of @available
			return @available[type].make(options)
		else
			throw new Error "Type '"+type+"' requested but not" +
				" provided by this factory."
