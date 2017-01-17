Renderable = require "../Abstract/Renderable"

# This class renders an image at the position of a Matter-JS body.
module.exports = class extends Renderable
	constructor: (@body, imgsrc, @width, @height) ->
		super()
		@image = new Image
		@image.src = imgsrc
	do_render: (context) ->
		context.save()

		context.moveTo(0,0);
		pos = @body.position;


		centerX = -@width/2
		centerY = -@height/2

		context.translate pos.x, pos.y
		context.rotate @body.angle
		context.drawImage(@image, centerX, centerY, @width, @height)
		
		context.restore()
