Game = require "../../Game"
Entities = require "./Entities"

class ThisModule extends Game.Modules.BaseModule

	install: (base) ->
		# Add entity subfactories
		for type of Entities
			factory = new Entities[type] base.context
			base.entities.register_entity type, factory

module.exports = new ThisModule
