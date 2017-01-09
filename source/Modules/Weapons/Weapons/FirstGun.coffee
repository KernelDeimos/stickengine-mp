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
