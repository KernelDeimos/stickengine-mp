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

	apply_velocity: (body, x, y) ->
		v_old = body.velocity
		v_new =
			x: v_old.x + x
			y: v_old.y + y
		Matter.Body.setVelocity(body, v_new)

	set_velocity: (body, x, y) ->
		v_old = body.velocity
		v_new =
			x: if x == null then v_old.x else x
			y: if y == null then v_old.y else y
		Matter.Body.setVelocity(body, v_new)
