Game = require "../../../Game"
Logic = Game.Logic

class ThrowAction extends Logic.Action
	perform: (params) ->
		throwee = params.throwee
		velocity = params.velocity

		throwee.throw velocity.x, velocity.y

module.exports = class
	make: () -> return new ThrowAction
