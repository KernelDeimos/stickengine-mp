modules = {}

modules.BaseMap = require "./BaseMap"
modules.StickFigures = require "./StickFigures"
modules.BaseLogic = require "./BaseLogic"
modules.Weapons = require "./Weapons"

module.exports =
	get_all: () ->
		return modules
