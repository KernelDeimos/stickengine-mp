Game = require "./Game"
Modules = require "./Modules"

module.exports = class
	build: (context) ->
		stage = new Game.Stage;
		entities = new Game.Entities.EntityFactory;
		game = new Game.Instance(context, stage, entities);

		return game

	install_all_modules: (game) ->
		modules = Modules.get_all()
		for mod in modules
			game.install_module(mod)
