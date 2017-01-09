Game = require "../../../Game"
Logic = Game.Logic

class GiveWeapon extends Logic.Action
	perform: (params) ->
		recipient = params.recipient
		weapon = params.weapon
		item = params.item

		recipient.emit 'receive_item.weapon', weapon, () ->
			item.despawn()

module.exports = class
	make: () -> return new GiveWeapon
