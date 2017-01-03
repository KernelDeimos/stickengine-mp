Matter = require "matter-js"
BaseEntity = require "./BaseEntity"

module.exports = class extends BaseEntity

	# @override
	constructor: (@type, @body, @uuid) ->
		super @type, @body, @uuid
		@walking = 0 # direction of  walking; -1, +1, or 0
		@walkingSpeed = 16 / 50 # 320 pt / s
		@jumpVelocity = 10

	# @override
	update: (deltaT) ->
		super deltaT
		walkAmount = @walking*@walkingSpeed*deltaT
		@move walkAmount, 0

	move: (x, y) ->
		Matter.Body.translate(@body, {x:x,y:y})

	jump: () ->
		Matter.Body.setVelocity(@body, {x:0,y:-1*@jumpVelocity})

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
