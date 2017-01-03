Bodies = (require "matter-js").Bodies
Game = require "../../../Game"

class CrateServer extends Game.Entities.BaseEntityCreature

class CrateClient extends Game.Entities.BaseEntityCreature
	set_renderable: (@renderable) ->
	get_renderable: () -> return @renderable

module.exports = class extends Game.Entities.BaseEntitySF
	# Make server version of the entity
	make_server: (id, props) ->
		body = Bodies.rectangle(0, 0, 60, 60)
		entity = new CrateServer('crate', body, id)
		return entity

	# Make client version of the entity
	make_client: (id, props) ->
		body = Bodies.rectangle(0, 0, 60, 60)
		entity = new CrateClient('crate', body, id)
		# entity.set_renderable new Game.Common.Render.BodyRenderable body
		entity.set_renderable new Game.Common.Render.ImageRenderable \
			body, '/images/crate.png', 60, 60
		return entity
