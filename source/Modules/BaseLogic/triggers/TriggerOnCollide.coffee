Game = require "../../../Game"
Logic = Game.Logic

class OnCollide extends Logic.Trigger

	constructor: (base) ->
		@events = base.events
		@lastTS = 0
		super

	activate: (params) ->
		console.log "Activating trigger"
		self = @

		if not 'entity' of params
			throw new Error "missing parameter: entity"

		# Make collide callback
		fCollide = (event) ->
			# Ensure this isn't a double-trigger
			ts = event.source.timing.timestamp
			if ts - @lastTS < 0.1
				return
			@lastTS = ts

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
