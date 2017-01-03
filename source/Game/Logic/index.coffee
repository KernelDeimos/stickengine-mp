module.exports = {}

# Base class for triggers to extend
module.exports.Trigger = class
	constructor: () ->
		# Map action parameters to event parameters
		@params_events = {}

		# Map action parameters to literal values
		@params_values = {}

		@debuginfo =
			type: "Trigger"
			name: "Abstract"


	# Set which event datum will be passed to an
	# action parameter when the trigger fires.
	#
	# @param actionKey name of parameter for action
	# @param eventKey name of event property to pass
	set_event_param: (actionKey, eventKey) ->
		@params_events[actionKey] = eventKey
		return @

	# Set a literal value to be passed to an
	# action parameter when the trigger fires.
	set_value_param: (actionKey, value) ->
		@params_values[actionKey] = value
		return @

	# Activates the trigger on the given parameters.
	# (i.e. compatible entities which can invoke the trigger)
	# This DOES NOT fire the trigger; it makes the trigger listen.
	with: (objects) ->
		try
			@.activate objects
		catch err
			console.log err

	# Sets the trigger to perform action.invoke(entity)
	# when it fire
	do: (@action) -> return @

	fire: (event) ->
		params = {}

		# Add literal parameters
		for key of @params_values
			params[key] = @params_values[key]

		# Add event parameters
		for key of @params_events
			prop = @params_events[key]
			params[key] = event[prop]

		@action.perform(params)

# Base class for actions to extend
module.exports.Action = class
	constructor: () ->
		@debuginfo =
			type: "Action"
			name: "Abstract"

	# Invoke this action on given parameters.
	#
	# If there is any issue with the parameters passed,
	# the action should log a warning to the console.
	perform: (params) ->
