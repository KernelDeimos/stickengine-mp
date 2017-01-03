Game = require "../../../Game"
Logic = Game.Logic

class OnCollide extends Logic.Trigger

	constructor: (base) ->
		@events = base.events
		super

	activate: (params) ->
		console.log "Activating trigger"
		self = @

		if not 'entity' of params
			throw new Error "missing parameter: entity"

		# Make collide callback
		fCollide = (event) ->
			# Create event for action
			ev = {
				'trigger': params.entity,
				'collider': event.entity
			}
			# Fire trigger
			self.fire(ev)

		# This event should invoke the physics engine
		@events.emit 'trigger.add_collide_callback', \
			params.entity.get_body(), fCollide

class OnCollideFactory
	constructor: (@physics) ->
	make: () ->
		return new OnCollide(@physics)

module.exports = OnCollideFactory
