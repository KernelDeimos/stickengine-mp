if not Matter? then Matter = require "matter-js"

Body = Matter.Body
Common = Matter.Common

ThisPlugin =
	name: 'matter-platformer-tools',

	version: '0.0.0',

	for: 'matter-js@^0.10.0',

	install: (base) ->
		base.after 'Engine.create', () ->
			ThisPlugin.Engine.afterCreate(this)

	Engine:
		afterCreate: (engine) ->
			# Implement per-body collision events
			Matter.Events.on engine, 'collisionStart', (ev) ->
				for pair in ev.pairs
					# Two combinations of the bodies
					combs = [
						[pair.bodyA,pair.bodyB]
						[pair.bodyB,pair.bodyA]
					]

					# Perform same task for each
					for comb in combs
						target = comb[0] # Entity being checked

						# Add 'other' property to event
						evNew = Object.assign {}, ev
						evNew.other = comb[1]

						# Trigger event on target
						Matter.Events.trigger \
							target, 'collisionStart', evNew

Matter.Plugin.register ThisPlugin

if module?
	module.exports = ThisPlugin

if window?
	window.MatterPlatformerTools = ThisPlugin
