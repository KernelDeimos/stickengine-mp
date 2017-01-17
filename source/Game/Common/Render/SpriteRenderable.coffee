Renderable = require "../Abstract/Renderable"
Lib = require "../../../Lib"

# This class renders an image at a specified position and angle
# At this point, this class should be re-named "GunRenderable"
module.exports = class extends Renderable
	constructor: (@spriteMeta, @coord) ->
		super()
		@angle = 0
		@direction = 'left'

		# Create image
		@image = new Image
		@image.src = @spriteMeta.location

		# Turn image meta into properties
		@width  = @spriteMeta.scale[0]
		@height = @spriteMeta.scale[1]

		# Prerender onto off-screen canvas
		@prerenderLeft = Lib.CanvasElementFactory.make_canvas \
			@width, @height
		ctx = @prerenderLeft.getContext '2d'
		ctx.drawImage(@image, 0, 0, @width, @height)

		@prerenderRight = Lib.CanvasElementFactory.make_canvas \
			@width, @height
		ctx = @prerenderRight.getContext '2d'
		ctx.save()
		ctx.scale -1, 1
		ctx.drawImage(@image, -@width, 0, @width, @height)
		ctx.restore()

		# Create the origin coordinate at meta coordinate
		@origin = new Lib.Geo.RelCoord @coord, 0, 0
		@origin.set_position \
			-@spriteMeta.origin[0], -@spriteMeta.origin[1]

		# Alt. origin for flipped image
		@originR = new Lib.Geo.RelCoord @coord, 0, 0
		@originR.set_position \
			-(@width-@spriteMeta.origin[0]),
			-@spriteMeta.origin[1]
	# constructor: (@coord, @angle, imgsrc, @width, @height) ->
	# 	super()
	# 	@image = new Image
	# 	@image.src = imgsrc

	set_angle: (@angle) ->
		if @angle > Math.PI/2
			@direction = 'left'
		else
			@direction = 'right'

	do_render: (context) ->
		ang = @angle
		origin = toDraw = null

		if @direction == 'left'
			toDraw = @prerenderLeft
			origin = @origin
			ang -= Math.PI
		else
			toDraw = @prerenderRight
			origin = @originR

		context.save()

		context.moveTo(0,0);
		coord = @coord.get_position() # coordinate of hand
		pos = origin.get_position() # position of handle


		centerX = -@width/2
		centerY = -@height/2

		context.translate coord.x, coord.y
		context.rotate ang
		context.translate pos.x-coord.x, pos.y-coord.y
		context.drawImage(toDraw, 0, 0, @width, @height)
		
		context.restore()

#=== TODO NEXT:
# > Create CanvasFactory for offscreen canvases
# > It'll be a static factory 'cause this could be easily changed
