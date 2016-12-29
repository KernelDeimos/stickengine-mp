modules = []

modules.push require "./Testing"

module.exports =
	get_all: () ->
		return modules
