# This class renders an image at the position of a Matter-JS body.
module.exports = class
	constructor: (@body, imgsrc, @width, @height) ->
		@image = new Image
		@image.src = imgsrc
	render: (context) ->
		context.save()

		vertices = @body.vertices;

		context.moveTo(0,0);
		pos = @body.position;


		centerX = -@width/2
		centerY = -@height/2

		context.translate pos.x, pos.y
		context.rotate @body.angle
		context.drawImage(@image, centerX, centerY, @width, @height)
		
		context.restore()
