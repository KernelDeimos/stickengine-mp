Game = require "../../../Game"
Logic = Game.Logic

class CreateProjectile extends Logic.Action
	perform: (params) ->
		name = params.entityName
		coord = params.coord
		angle = params.angle

		

module.exports = class
	make: () -> return new CreateProjectile
