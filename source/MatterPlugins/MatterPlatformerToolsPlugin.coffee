if not Matter? then Matter = require "matter-js"

Body = Matter.Body
Common = Matter.Common

ThisPlugin =
	name: 'matter-platformer-tools',

	version: '0.0.0',

	for: 'matter-js@^0.10.0',

	options:
		jump_test_iters: 10

	install: (base) ->
		base.after 'Engine.create', () ->
			ThisPlugin.Engine.afterCreate(this)

	Engine:
		afterCreate: (engine) ->
			# Implement per-body collision events
			trigger_event_on_body = (eventType) ->
				Matter.Events.on engine, eventType, (ev) ->

					for pair in ev.pairs
						# Two combinations of the bodies
						combs = [
							[pair.bodyA,pair.bodyB]
							[pair.bodyB,pair.bodyA]
						]

						# Perform same task for each
						for comb in combs
							target = comb[0] # body being checked

							# Add 'other' property to event
							evNew = Object.assign {}, ev
							evNew.other = comb[1]

							# Trigger event on target
							Matter.Events.trigger \
								target, eventType, evNew
			for eventType in [
				'collisionStart'
				'collisionEnd'
				'collisionActive'
			]
				trigger_event_on_body eventType

			return undefined

	Body:
		enable_jump_detector: (body) ->
			console.log "JUMP DETECTOR"
			console.log body
			body.canJump = false
			Matter.Events.on body, 'collisionActive', (ev) ->
				# console.log 'collisionStart'
				body.canJump = true
			Matter.Events.on body, 'collisionEnd', (ev) ->
				# console.log 'collisionEnd'
				body.canJump = false

Matter.Plugin.register ThisPlugin

if module?
	module.exports = ThisPlugin

if window?
	window.MatterPlatformerTools = ThisPlugin
