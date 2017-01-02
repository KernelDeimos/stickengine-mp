Matter = require 'matter-js'

Game = require "../../../Game"

class PlatformServer extends Game.Entities.BaseEntityCreature

class PlatformClient extends Game.Entities.BaseEntityCreature
	set_renderable: (@renderable) ->
	get_renderable: () -> return @renderable

module.exports = class extends Game.Entities.BaseEntitySF
	# Make server version of the entity
	make_server: (id, props) ->
		body = @_make_body(props)
		entity = new PlatformServer('platform', body, id)
		return entity

	# Make client version of the entity
	make_client: (id, props) ->
		body = @_make_body(props)
		entity = new PlatformClient('platform', body, id)
		entity.set_renderable new Game.Common.Render.BodyRenderable body
		return entity

	_make_body: (props) ->
		p = props

		# Fix for top-left positioning
		x = p.x + 0.5*p.w
		y = p.y + 0.5*p.h

		body = Matter.Bodies.rectangle(x, y, p.w, p.h)
		Matter.Body.setStatic(body, true)
		return body
