Body = (require "matter-js").Body # For body transformations
Lib = require "../../Lib" # For serializing body

module.exports = class

	constructor: (@type, @body, @uuid) ->

	get_type: () -> @type
	get_body: () -> @body

	set_position: (x, y) ->
		if typeof x is 'object'
			Body.setPosition(@body, x)
		else
			Body.setPosition(@body, {x:x,y:y})

	get_position: () -> @body.position

	get_renderable: () ->
		renderable =
			render: () -> # do nothing

	# Serialize enough entity data to recreate on client
	serialize: () ->
		# Add one-time-only properties
		data =
			type: @type
		# Add every-time properties
		Object.assign data, @serialize_update()
		# Return object
		return data

	# Serialize enough entity data to update the client
	serialize_update: () ->
		data =
			uuid: @uuid,
			body_data: Lib.Body.serialize(@body)

	deserialize_update: (datum) ->
		dat  = datum.body_data
		Lib.Body.update_from_serialized_data @body, dat

	# @param deltaT time difference in (milliseconds?)
	update: (deltaT) ->

	set_id: (@uuid) ->
	get_id: () -> @uuid
