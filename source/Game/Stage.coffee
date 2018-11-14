Emitter = require 'events'

# The stage is a data structure and event source for entities.
#
# Entities, when added, are added to an array maintained by
# this class. Additionally, an event is triggered to inform
# any listeners that an entity was added.
module.exports = class extends Emitter
	constructor: () ->
		super()
		@entities = []

	# @param [Object] entity  any subclass of BaseEntity
	add_entity: (entity) ->
		@entities.push entity
		@emit('stage.add_entity', entity)

		type = entity.get_type()
		@emit('stage.add_entity.'+type, entity)

	# @param [Object] entity  any subclass of BaseEntity
	rem_entity: (entity) ->

		# @entities = @entities.filter (ent) ->
		# 	console.log ent.uuid
		# 	return ent.uuid != entity.uuid
		for ent, i in @entities
			@entities.splice i, 1 if ent is entity

		@emit('stage.rem_entity', entity)
		
		type = entity.get_type()
		@emit('stage.rem_entity.'+type, entity)

	# @return [Array]  list of entity objects
	get_entities: () -> @entities

	# @return [Object]  subclass of BaseEntity
	get_entity_by_id: (id) ->
		for entity in @entities
			if id == entity.get_id()
				return entity
		return null

	# Receives delta time and updates the
	# stage accordingly. This will be called
	# by the physics engine on every tick.
	#
	# @param deltaT  change in time as given by physics engine
	update: (deltaT) ->
		@emit('stage.before_update')
		# Update all entities in stage
		for entity in @entities
			entity.update(deltaT)
