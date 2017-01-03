Game = require "../../Game"
Entities = require "./Entities"

class ThisModule extends Game.Modules.BaseModule

	depends: () ->
		[
			'BaseLogic'
		]

	install: (base) ->
		# Add entity subfactories
		for type of Entities
			factory = new Entities[type] base.context
			base.entities.register_entity type, factory

		## Rule: Jumping platforms should launch things
		base.stage.on 'stage.add_entity.jumper', (entity) ->
			trig = base.triggers.make 'collide' # On a collision,
			action = base.actions.make 'throw'  # throw something!

			trig.do action
			trig.set_event_param 'throwee', 'collider'
			trig.set_event_param 'thrower', 'trigger'
			trig.set_value_param 'velocity',
				x: 0
				y: -entity.velocity / 25
			trig.with
				entity: entity

module.exports = new ThisModule
