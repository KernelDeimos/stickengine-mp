Body = (require "matter-js").Body # For body transformations
Lib = require "../Lib" # For serializing body

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

	# Serialize enough entity data to recreate on client
	serialize: () ->
		data =
			type: @type,
			uuid: @uuid,
			body_data: Lib.Body.serialize(@body)

	# Serialize enough entity data to update the client
	serialize_update: () ->
		data =
			uuid: @uuid,
			position: @body.position

	# @param deltaT time difference in (milliseconds?)
	update: (deltaT) ->

	set_id: (@uuid) ->
	get_id: () -> @uuid
