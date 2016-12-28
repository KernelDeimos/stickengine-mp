Matter = require "matter-js"
Context = require "../Context"

module.exports = class
	constructor: (@context, @stage) ->
		@engine = Matter.Engine.create()

		@last_ms = 0 # Last tick for physics engine

		@_bind()

	_bind: () ->
		self = @

		# Physics Events
		Matter.Events.on @engine, 'beforeUpdate', (ev) ->
			# Calculate time difference
			ms = ev.timestamp
			remtaT = ms - self.last_ms
			self.last_ms = ms
			# Update stage (and thus, all entities)
			self.stage.update(deltaT)

			return

		# Stage Events
		@stage.on 'stage.add_entity', (entity) ->
			self.add_body entity.get_body()

		@stage.on 'stage.rem_entity', (entity) ->
			self.rem_body entity.get_body()

	add_body: (body) ->
		Matter.World.add @engine.world, [body]

	rem_body: (body) ->
		Matter.World.remove @engine.world, [body]

	activate: () ->
		# Use default runner for client
		if @context.env is Context.ENV_CLIENT
			Matter.Engine.run(@engine)

		# Default runner isn't server compatible,
		# so run something else
		else if @context.env is Context.ENV_SERVER
			@_activate_servermode()

	_activate_servermode: () ->
		self = @
		setInterval () ->
			Matter.Engine.update self.engine, 16.7
		, 16.7
