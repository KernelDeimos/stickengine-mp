Renderable = require "../Abstract/Renderable"

# This class renders an image at the position of a Matter-JS body.
module.exports = class extends Renderable
	constructor: (@renderable) ->
		super()
	set_renderable: (@renderable) ->
	do_render: (context) ->
		if @renderable?
			@renderable.render context
