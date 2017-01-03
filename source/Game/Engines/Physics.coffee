Matter = require "matter-js"
Context = require "../Context"

module.exports = class
	constructor: () ->
		@engine = Matter.Engine.create()

		@last_ms = 0 # Last tick for physics engine

		# key -> body id; value -> [callback,...]
		@bodyCollideListeners = {}
		# key -> body id; value -> entity
		@bodyToEntityMap = {}

	_bind: () ->
		self = @

		# Physics Events
		Matter.Events.on @engine, 'beforeUpdate', (ev) ->
			# Calculate time difference
			ms = ev.timestamp
			deltaT = ms - self.last_ms
			self.last_ms = ms
			# Update stage (and thus, all entities)
			self.stage.update(deltaT)

			return

		Matter.Events.on @engine, 'collisionStart', (ev) ->
			for pair in ev.pairs
				idA = pair.bodyA.id
				idB = pair.bodyB.id

				# Check if body ID is being listened to
				if idA of self.bodyCollideListeners
					# Get entity reference from body id
					ev.entity = self.bodyToEntityMap[idB]
					# call all listeners
					for l in self.bodyCollideListeners[idA]
						l(ev)

				# Perform same tasks as above for object B
				if idB of self.bodyCollideListeners
					ev.entity = self.bodyToEntityMap[idA]
					for l in self.bodyCollideListeners[idB]
						l(ev)

		# Stage Events
		@stage.on 'stage.add_entity', (entity) ->
			body = entity.get_body()
			# Remember which entity this belongs to
			# (for collision events)
			self.bodyToEntityMap[body.id] = entity
			# Add body to the Matter-JS world
			self.add_body body

		@stage.on 'stage.rem_entity', (entity) ->
			self.rem_body entity.get_body()

	add_body: (body) ->
		Matter.World.add @engine.world, [body]

	rem_body: (body) ->
		Matter.World.remove @engine.world, [body]

	activate: (@context, @stage, @events) ->
		@_bind()
		
		# Use default runner for client
		if @context.env is Context.ENV_CLIENT
			Matter.Engine.run(@engine)

		# Default runner isn't server compatible,
		# so run something else
		else if @context.env is Context.ENV_SERVER
			@_activate_servermode()

		self = @

		@events.on 'trigger.add_collide_callback', \
		(body, callback) ->
			# Push callback to list, or create list with callback
			if self.bodyCollideListeners[body.id]?
				self.bodyCollideListeners[body.id].push(callback)
			else self.bodyCollideListeners[body.id] = [callback]

	_activate_servermode: () ->
		self = @
		setInterval () ->
			Matter.Engine.update self.engine, 16.7
		, 16.7
