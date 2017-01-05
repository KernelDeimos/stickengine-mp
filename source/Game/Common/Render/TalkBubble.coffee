Renderable = require "../Abstract/Renderable"

# This class renders an image at the position of a Matter-JS body.
module.exports = class extends Renderable
	# Creates a talk bubble, invisible by default.
	#
	# @param [Object] body  Matter-JS body of entity
	# @param [int] yOffset  Height of talk bubble position
	constructor: (@body, @yOffset) ->
		super()
		# Things that are constants for now
		@durration = 4800
		# Initialize
		@text = 'Text for Testing'
		@timeSinceUpdate = 0
		@isVisible = false
	do_render: (context) ->
		# Do nothing if bubble is invisible
		if not @isVisible then return

		# Otherwise, draw at body position - offset
		pos = @body.position
		x = pos.x
		y = pos.y - @yOffset

		context.save()

		context.fillStyle = '#000'
		if @text.length < 8
			context.font = "32px serif";
		else if @text.length < 30
			context.font = "18px serif";
		else
			context.font = "12px serif";
		context.textAlign = 'center';
		context.fillText @text, x, y
		
		context.restore()
	update: (deltaT) ->
		# Time-out text bubble after a bit
		@timeSinceUpdate += deltaT
		if @timeSinceUpdate > @durration
			@isVisible = false
	show_message: (@text) ->
		# Reset timer and show bubble
		@timeSinceUpdate = 0
		@isVisible = true
		console.log 'bubble'
