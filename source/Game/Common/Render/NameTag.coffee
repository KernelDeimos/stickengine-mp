Renderable = require "../Abstract/Renderable"

# This class renders an image at the position of a Matter-JS body.
module.exports = class extends Renderable
	# Creates a talk bubble, invisible by default.
	#
	# @param [Object] body  Matter-JS body of entity
	# @param [int] yOffset  Height of talk bubble position
	constructor: (@body, @yOffset) ->
		super()
		@text = 'Untitled Human'
	do_render: (context) ->
		# draw at body position - offset
		pos = @body.position
		x = pos.x
		y = pos.y - @yOffset

		context.save()

		context.fillStyle = '#000'
		context.font = "14px serif";
		context.textAlign = 'center';
		context.fillText @text, x, y
		
		context.restore()
	set_text: (@text) ->
