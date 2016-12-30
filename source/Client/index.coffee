Game = require "../Game"
GameBuilder = require "../GameBuilder"

ClientConsole = require "./ClientConsole"
ServerSync = require "./ServerSync"

module.exports = class
	constructor: (@canvas, @ws) ->
		@userconsole = new ClientConsole

	start: () ->
		# === Build Engines ===
		physics = new Game.Engines.Physics
		render  = new Game.Engines.Render @canvas, window

		# === Build Game ===
		builder = new GameBuilder
		@game = builder.build
			env: Game.Context.ENV_CLIENT

		@game.add_engine physics
		@game.add_engine render

		builder.install_all_modules(@game)

		# === Modify Game ===
		player = @game.add_entity 'crate'

		# Engine to update camera position
		@game.add_engine new (class
			activate: (context, stage) -> stage.on \
				'stage.before_update', () ->
					render.center_camera player.get_position()
		)

		# === POST GAME INITIALIZATION ===

		# Instanciate keyboard
		keyboard = new Game.Misc.InputHandler
		keyboard.bind document

		# Instanciate server synchronizer
		serversync = new ServerSync @ws, player, @userconsole, keyboard
		@game.install_module serversync
		serversync.activate()

		# Expose keyboard for enable and disable functions
		@keyboard = keyboard

		@_poll_inputs keyboard, player

	do_test: () ->
		@game.add_entity 'platform',
			x: 400
			y: 600
			w: 800
			h: 20

	get_console: () -> return @userconsole

	ignore_inputs: () -> @keyboard.disable()
	accept_inputs: () -> @keyboard.enable()

	_poll_inputs: (keyboard, player) ->

		controller = new Game.Misc.CreatureController player

		setInterval () ->
			for ctrl in keyboard.get_events()
				controller.update_control ctrl.name, ctrl.state
		, 10
