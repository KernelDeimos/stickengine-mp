modules = []

modules.push require "./Testing"
modules.push require "./StickFigures"

module.exports =
	get_all: () ->
		return modules
