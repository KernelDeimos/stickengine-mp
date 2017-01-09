# +++++++
# - contributed by my cat

Matter = require "matter-js"
MatterPlugins = require "../../MatterPlugins"
PTBody = MatterPlugins.PlatformerTools.Body
BaseEntity = require "./BaseEntity"

module.exports = class extends BaseEntity

	# @override
	constructor: (@type, @body, @uuid) ->
		super @type, @body, @uuid

	# @override
	update: (deltaT) ->
		super deltaT
