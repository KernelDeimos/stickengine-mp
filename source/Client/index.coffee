Game = require "../Game"
ClientConsole = require "./ClientConsole"
GameBuilder = require "../GameBuilder"

module.exports = class
	constructor: (@canvas, @ws) ->
		@userconsole = new ClientConsole

	start: () ->
		# Build Engines
		physics = new Game.Engines.Physics
		render  = new Game.Engines.Render @canvas, window

		# Build Game
		builder = new GameBuilder
		@game = builder.build
			env: Game.Context.ENV_CLIENT

		@game.add_engine physics
		@game.add_engine render

		builder.install_all_modules(@game)

	do_test: () ->
		@game.add_entity 'platform',
			x: 400
			y: 600
			w: 800
			h: 20

		@game.add_entity 'crate'

	get_console: () -> return @userconsole
