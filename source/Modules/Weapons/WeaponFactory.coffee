Game = require "../../Game"
Weapons = require "./Weapons"

WeaponFactory = class extends Game.Base.FactoryTemplate

module.exports = () ->
	factory = new WeaponFactory
	# Add weapon subfactories
	for type of Weapons
		subf = new Weapons[type]
		factory.add_factory type, subf

	return factory
