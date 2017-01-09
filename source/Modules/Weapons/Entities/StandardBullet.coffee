Game = require "../../../Game"

# Yo dawg I heard you like parent directories so I...
Lib = require "../../../Lib"
Geo = Lib.Geo

class BaseBullet extends Game.Entities.BaseEntity
class BulletServer extends BaseBullet
class BulletClient extends BaseBullet
	setup: (@renderable) ->
		super()
	get_renderable: () -> return @renderable

module.exports = class extends Game.Entities.BaseEntitySF
	# Make server version of the entity
	make_server: (id, props) ->

	# Make client version of the entity
	make_client: (id, props) ->
		