Matter = require "matter-js"
Body = Matter.Body

# Additional body manipulation functions, and serialization for
# body information between client and server
module.exports =
	serialize: (body) ->
		data =
			velocity: body.velocity
			position: body.position
			angle: body.angle
			angularVelocity: body.angularVelocity

	update_from_serialized_data: (body, data) ->
		Body.set(body, data)

	set_can_rotate: (body, value) ->
			if value
				Matter.Body.setInertia(body, 0)
			else
				Matter.Body.setInertia(body, Infinity)
