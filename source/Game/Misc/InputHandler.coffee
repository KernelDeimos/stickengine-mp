Emitter = require("events")
ƒ = require "../../Lib/Utilities"

module.exports = class extends Emitter

	constructor: () ->

		@KEYSTATE_DOWN = 'down'
		@KEYSTATE_UP = 'up'

		@paused = false

		# Store controls in two different ways for speed
		@controlsByName = {}
		@controlsByCode = {}
		# Store clicked controls here
		@controlsClicked = []
		@controlsOn = []

		# Assign some typical defaults
		# TODO: load from configuration object
		@assign_control 'up'      ,  87
		@assign_control 'left'    ,  65
		@assign_control 'down'    ,  83
		@assign_control 'right'   ,  68
		@assign_control 'prev'    ,  69
		@assign_control 'next'    ,  82
		@assign_control 'taunt'   ,  84
		# @assign_control 'console' , 192
		@assign_control 'space'   ,  32

	assign_control: (name, code) ->
		@controlsByName[name] = @controlsByCode[code] =
			name: name
			code: code
			state: @KEYSTATE_UP

	bind: (documentObject) ->
		self = @

		documentObject.addEventListener 'keydown', (e) ->
			if not self.paused
				self._process_key_event(e, self.KEYSTATE_DOWN)
		, false

		documentObject.addEventListener 'keyup', (e) ->
			if not self.paused
				self._process_key_event(e, self.KEYSTATE_UP)
		, false

	get_key_state: (controlName) -> @controlsByName[controlName].state

	get_events: () ->
		clicked = @controlsClicked
		@controlsClicked = []
		return clicked

	# Stops listening and allows keyboard events to fall through.
	disable: () ->
		@paused = true
		# Release any keys currently being held down
		for control in @controlsOn by -1
			# Remove from list of active controls
			ƒ.remove_from_list control, @controlsOn
			# Update the state
			control.state = @KEYSTATE_UP
			# Update listeners
			@controlsClicked.push control
			@emit(control.name, control.state)
			@emit('any', control.name, control.state)
	# Resumes listening, preventing default key actions.
	enable:  () -> @paused = false

	_process_key_event: (e, state) ->
		# Ignore if keycode not present
		if e.keyCode not of @controlsByCode then return

		# Get control object
		control = @controlsByCode[e.keyCode]
		# If state has not changed, do nothing
		if control.state == state then return

		# Emit keyboard event
		@emit(control.name, state)
		@emit('any', control.name, state)

		# Set control state
		control.state = state
		# Add control to key events
		@controlsClicked.push control
		# Add or remove from keys being held down
		if state == @KEYSTATE_DOWN then @controlsOn.push control
		else ƒ.remove_from_list control, @controlsOn

		# Disable default keyboard handling
		e.preventDefault()
		return
