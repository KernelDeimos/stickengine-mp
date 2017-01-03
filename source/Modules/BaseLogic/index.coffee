Game = require "../../Game"

Triggers = require "./triggers"
Actions  = require "./actions"

class ThisModule extends Game.Modules.BaseModule

	install: (base) ->
		# Add triggers
		for type of Triggers
			factory = new Triggers[type] base
			base.triggers.add_factory type, factory
		# Add actions
		for type of Actions
			factory = new Actions[type] base
			base.actions.add_factory type, factory

module.exports = new ThisModule
