Bodies = (require "matter-js").Bodies
Body = (require "matter-js").Body
Game = require "../../../Game"

# Yo dawg I heard you like parent directories so I...
Lib = require "../../../Lib"
Geo = Lib.Geo

resources = require "../resources"

class BaseBullet extends Game.Entities.BaseEntity
	set_angle: (@angle) ->
		console.log "Angle:"
		console.log @angle
		Body.setAngle(@body, @angle)
	fire: () ->
		vel =
			x: 50*Math.cos(@angle)
			y: 50*Math.sin(@angle)
		Body.setVelocity(@body, vel)
class BulletServer extends BaseBullet
class BulletClient extends BaseBullet
	setup: (@renderable) ->
	get_renderable: () -> return @renderable
	# set_angle: (angle) ->
	# 	console.log "Angle:"
	# 	console.log angle
	# 	Body.setAngle(@body, angle)

module.exports = class extends Game.Entities.BaseEntitySF
	# Make server version of the entity
	make_server: (id, props) ->
		body = @_make_body()
		entity = new BulletServer 'bullet_std', body, id
		# entity.setup
		return entity


	# Make client version of the entity
	make_client: (id, props) ->
		body = @_make_body()
		sprite = resources['proj/stdbullet']
		console.log sprite
		renderable = new Game.Common.Render.ImageRenderable \
			body, sprite.location, sprite.scale[0], sprite.scale[1]
		# bodyPositionAdapter =
		# 	get_position: () ->
		# 		result = body.position
		# renderable = new Game.Common.Render.SpriteRenderable \
		# 		sprite, bodyPositionAdapter
		entity = new BulletClient 'bullet_std', body, id
		entity.setup renderable
		return entity

	_make_body: () ->
		body = Bodies.rectangle(0, 0, 30, 7)
		Body.setDensity(body, 0.1)
		Lib.Body.set_can_rotate(body, false)
		return body
		