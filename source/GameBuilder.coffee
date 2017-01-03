Game = require "./Game"
Modules = require "./Modules"

module.exports = class
	build: (context) ->
		stage = new Game.Stage
		entities = new Game.Entities.EntityFactory
		actions  = new Game.Base.FactoryTemplate
		triggers = new Game.Base.FactoryTemplate
		game = new Game.Instance \
			# Main Components
			context, stage, \
			# Factories
			entities, actions, triggers

		return game

	install_all_modules: (game) ->
		modules = Modules.get_all()

		# Empty list to track installed modules
		# (for when a module was a dependancy)
		installed = []

		# Loop through all modules
		for mod of modules
			# Skip if already added
			if mod in installed then continue

			module = modules[mod]

			# Loop through module dependancies
			for dmod in module.depends()
				# Skip if already added
				if dmod in installed then continue

				# Install dependancy
				dmodule = modules[dmod]
				game.install_module dmodule
				installed.push dmod

			# Install module
			game.install_module module
			installed.push mod
