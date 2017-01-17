# This is a convenience class to convert key states into
# player movement.
module.exports = class
	constructor: (@creature) ->
		@KEYSTATE_UP = 'up'
		@KEYSTATE_DOWN = 'down'

	update_control: (name, state) ->
		walking = @creature.is_walking()

		up   = state == @KEYSTATE_UP
		down = state == @KEYSTATE_DOWN

		# Walk left or stop
		if name == 'left'
			if walking == -1 and up
				@creature.walk 'none'
			else if down
				@creature.walk 'left'

		# Walk right or stop
		if name == 'right'
			if walking == +1 and up
				@creature.walk 'none'
			else if down
				@creature.walk 'right'

		if name == 'up' and down
			@creature.jump()

		if name == 'space' and down
			@creature.hold_trigger()
		if name == 'space' and up
			@creature.lift_trigger()
