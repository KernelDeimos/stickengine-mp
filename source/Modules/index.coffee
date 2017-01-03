modules = {}

modules.BaseMap = require "./BaseMap"
modules.StickFigures = require "./StickFigures"
modules.BaseLogic = require "./BaseLogic"

module.exports =
	get_all: () ->
		return modules
