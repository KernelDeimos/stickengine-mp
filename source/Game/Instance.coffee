# The game class provides an interface to game modules.

module.exports = class
	constructor: (@context, @stage, @entities, @actions, @triggers) ->

	add_engine: (engine) ->
		engine.activate @context, @stage

	install_module: (module) ->
		base =
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

	get_entities: () -> @stage.get_entities()
