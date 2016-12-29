# This is a convenience class to convert key states into
# player movement.
module.exports = class
	constructor: (@creature) ->
		@KEYSTATE_UP = 'up'
		@KEYSTATE_DOWN = 'down'

	update_control: (name, state) ->
		walking = @creature.is_walking()

		# Walk left or stop
		if name == 'left'
			if walking == -1 and state == @KEYSTATE_UP
				@creature.walk 'none'
			else if state == @KEYSTATE_DOWN
				@creature.walk 'left'

		# Walk right or stop
		if name == 'right'
			if walking == +1 and state == @KEYSTATE_UP
				@creature.walk 'none'
			else if state == @KEYSTATE_DOWN
				@creature.walk 'right'

		if name == 'up' and state == @KEYSTATE_DOWN
			@creature.jump()