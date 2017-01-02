module.exports = class
	install: (base) ->
		@entities = base.entities
		@stage = base.stage
	load_map: (data) ->
		for object in data.objects
			# === Create options object
			options = if object.options? then object.options else {}

			# Get data 
			type = object.type

			# TEMPORARY
			if type == 'jumper' then type = 'platform'

			id   = if object.id? then object.id else undefined
			opts = object.options
			
			# Make the entity
			entity = @entities.make type, id, opts

			# Add entity to the stage
			@stage.add_entity entity

		return null
