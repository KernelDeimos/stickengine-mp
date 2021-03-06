# +++++++
# - contributed by my cat

Matter = require "matter-js"
MatterPlugins = require "../../MatterPlugins"
PTBody = MatterPlugins.PlatformerTools.Body
BaseEntity = require "./BaseEntity"

module.exports = class extends BaseEntity

	# @override
	constructor: (type, body, uuid) ->
		super type, body, uuid
		@type = type
		@body = body
		@uuid = uuid
		@walking = 0 # direction of  walking; -1, +1, or 0
		@walkingSpeed = 16 / 50 # 320 pt / s
		@jumpVelocity = 10
		PTBody.enable_jump_detector @body
	# @override
	update: (deltaT) ->
		super deltaT
		walkAmount = @walking*@walkingSpeed*deltaT
		@move walkAmount, 0

	move: (x, y) ->
		Matter.Body.translate(@body, {x:x,y:y})

	jump: () ->
		if @body.canJump
			Matter.Body.setVelocity(@body, {x:0,y:-1*@jumpVelocity})
		# Matter.Body.applyForce(@body, @body.position, {x:0,y:1*0.5})

	# @param [String] direction  'left', 'right', or 'stop'
	walk: (direction) ->
		if direction == 'left'
			@walking = -1
		else if direction == 'right'
			@walking = 1
		else
			@walking = 0

	is_walking: () ->
		if @walking == 0 then return false
		else return @walking

	hold_trigger: () ->
	lift_trigger: () ->
