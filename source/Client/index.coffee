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
		player = @game.add_entity 'stickhuman'

		# Engine to update camera position
		@game.add_engine new (class
			activate: (context, stage) -> stage.on \
				'stage.before_update', () ->
					render.center_camera player.get_position()
		)

		@loader = new Game.MapLoader
		@game.install_module @loader

		# === POST GAME INITIALIZATION ===

		# Instanciate keyboard and mouse
		keyboard = new Game.Misc.InputHandler
		keyboard.bind document
		mouse = new Game.Misc.CanvasMouseHandler @canvas

		# Instanciate server synchronizer
		serversync = new ServerSync @ws, player, @userconsole, keyboard
		@game.install_module serversync
		serversync.activate()

		# Expose keyboard for enable and disable functions
		@keyboard = keyboard

		@_poll_inputs player, keyboard, mouse

	load_map: (mapData) ->
		@loader.load_map mapData

	do_test: () ->
		@game.add_entity 'platform',
			x: -400
			y: 600
			w: 3200
			h: 20

	get_console: () -> return @userconsole

	ignore_inputs: () -> @keyboard.disable()
	accept_inputs: () -> @keyboard.enable()

	_poll_inputs: (player, keyboard, mouse) ->

		controller = new Game.Misc.CreatureController player

		self = @

		setInterval () ->
			for ctrl in keyboard.get_events()
				controller.update_control ctrl.name, ctrl.state

			# Update aim angle
			mpos = mouse.get_coordinates()
			ydiff = mpos.y - self.canvas.height/2
			xdiff = mpos.x - self.canvas.width/2
			angle = Math.atan ydiff / xdiff
			if xdiff < 0 then angle += Math.PI
			player.set_angle angle
		, 10

		setInterval () ->
			# console.log player.aimAngle
			mpos = mouse.get_coordinates()
			ydiff = mpos.y - self.canvas.height/2
			xdiff = mpos.x - self.canvas.width/2
			angle = Math.atan ydiff / xdiff
			if xdiff < 0 then angle += Math.PI
			# console.log [xdiff , ydiff]
			console.log angle*360/(2*Math.PI)
		, 500

