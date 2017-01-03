Game = require "../../../Game"
Logic = Game.Logic

class OnCollide extends Logic.Trigger

	constructor: (base) ->
		@physics = base.physics
		super

	activate: (objects) ->
		console.log "Activating trigger"
		self = @

		if not 'entity' of objects
			throw new Error "missing parameter: entity"

		@physics.on_entity_collide objects.entity, (event) ->
			ev = {
				'trigger': objects.entity,
				'collider': event.entity
			}
			self.fire(ev)

class OnCollideFactory
	constructor: (@physics) ->
	make: () ->
		return new OnCollide(@physics)

module.exports = OnCollideFactory
