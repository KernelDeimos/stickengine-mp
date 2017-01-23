Game = require "../../../Game"
resources = require "../resources"

# Yo dawg I heard you like parent directories so I...
Lib = require "../../../Lib"
Geo = Lib.Geo

module.exports = class
	make: (params) ->
		name: 'firstgun'
		sprite: resources['wep/firstgun']
		bullet: 'bullet_std'
		fire: (api, position, angle) ->
			bull = api.entities.make('bullet_std')
			bull.set_position position.x, position.y
			bull.set_angle angle
			api.stage.add_entity bull
