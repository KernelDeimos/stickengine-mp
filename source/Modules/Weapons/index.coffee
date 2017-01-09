Game = require "../../Game"
Entities = require "./Entities"
Actions = require "./Actions"

class ThisModule extends Game.Modules.BaseModule

	install: (base) ->
		# Add entity subfactories
		for type of Entities
			factory = new Entities[type] base.context
			base.entities.register_entity type, factory
		# Add actions
		for type of Actions
			factory = new Actions[type] base
			base.actions.add_factory type, factory

		## Rule: Jumping platforms should launch things
		base.stage.on 'stage.add_entity.weapon', (weaponItem) ->
			trig = base.triggers.make 'collide' # On a collision,
			action = base.actions.make 'give.weapon'

			trig.do action
			trig.set_event_param 'recipient', 'collider'
			trig.set_value_param 'item', weaponItem
			trig.set_value_param 'weapon', weaponItem.get_weapon()
			trig.with
				entity: weaponItem

module.exports = new ThisModule

# Tasks:
# :: Create BaseEntityItem
# :: Create Weapon class
#    w/ get_image
#    actually no just use the resource
# :: Create Bullet class

# :: Create WeaponItem
