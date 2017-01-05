# The game class provides an interface to game modules.
Emitter = require "events"

module.exports = class
	constructor: (@context, @stage, @entities, @actions, @triggers) ->
		@events = new Emitter # Events emitted by engines or modules

	add_engine: (engine) ->
		engine.activate @context, @stage, @events

	install_module: (module) ->
		base =
			events: @events
			context: @context
			stage: @stage
			entities: @entities
			actions: @actions
			triggers: @triggers
		module.install base

	add_entity: (type, props) ->
		entity = @entities.make type, null, props
		@stage.add_entity entity
		return entity

	rem_entity: (entity) ->
		@stage.rem_entity entity

	get_entities: () -> @stage.get_entities()
