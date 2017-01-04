Context = require "./Context"

module.exports = class
	constructor: () ->
		@labelEntityMap = {}

	install: (base) ->
		@entities = base.entities
		@triggers = base.triggers
		@actions = base.actions
		@stage = base.stage
		@context = base.context
	load_map: (data) ->
		for object in data.objects
			# === Create options object
			options = if object.options? then object.options else {}

			if object.type.charAt(0) == '%'
				@_process_logic object
			else
				@_process_entity object

			

		return null

	_process_entity: (object) ->
		id   = if object.id? then object.id else undefined

		# Do not create "server objects" on client, since
		# the server will send these after connecting.
		if object.server?
			if @context.env == Context.ENV_CLIENT
				return
		
		# Make the entity
		entity = @entities.make object.type, id, object.options

		# Add entity to the stage
		@stage.add_entity entity

		# Check for explicitly defined position
		if object.position?
			entity.set_position object.position

		# If the object has a label, store it in the map of
		# referrable objects (for triggers and the like)
		if object.label?
			if object.label of @labelEntityMap
				console.log 'Warning: map loaded with duplicate' +
					' label for "'+object.label+'"'
			@labelEntityMap[object.label] = entity

	_process_logic: (object) ->
		# Do not add map triggers on client
		if @context.env == Context.ENV_CLIENT
			return

		if object.type == '%trigger'
			trig = @triggers.make object.on
			action = @actions.make object.do

			trig.do action

			# Set parameters to action from event
			for key of object.event_params
				trig.set_event_param key, object.event_params[key]

			# Set parameters to action from literal
			for key of object.value_params
				trig.set_value_param key, object.value_params[key]

			# Set trigger options
			options = {}
			for key of object.with
				value = object.with[key]
				# If the value is an object, we'll need to
				# get the /actual/ value from somewhere else
				if typeof value == 'object'
					# Check if the object is retrieved by label
					if 'from_label' of value
						label = value.from_label
						# Make sure label actually exists
						if not object.label of @labelEntityMap
							console.log 'Warning: trigger parameter' +
								' could not be satisfied. Trigger' +
								' was not created.'
							return
						# Get value from entity by label
						value = @labelEntityMap[label]
				# else, do nothing - value is literal value
				# Add value to options
				options[key] = value

			# Activate trigger with given options
			console.log "ITS HERE"
			console.log options
			trig.with options





