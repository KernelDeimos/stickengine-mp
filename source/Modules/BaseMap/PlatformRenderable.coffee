# This class renders a Matter-JS body.
module.exports = class
	constructor: (@body, @velocity) ->
		@thickness = 2
		@fill_colour   = 'rgb(255,255,255)'
		@stroke_colour = 'rgb(0,0,0)'
		@HIGH_VEL = 2000
	render: (context) ->
		context.beginPath()

		body = @body

		vertices = body.vertices;

		# Set stroke & fill styles
		context.lineWidth = @thickness;
		if @velocity?
			@_colour_by_velocity(context)
		else
			context.strokeStyle = @stroke_colour;
			context.fillStyle = @fill_colour;

		# Draw platform
		context.beginPath()
		context.moveTo 0 , 0
		pos = body.position;

		context.moveTo(vertices[0].x, vertices[0].y);
		for j in [1...vertices.length]
			context.lineTo(vertices[j].x, vertices[j].y);
		context.lineTo(vertices[0].x, vertices[0].y);

		context.closePath()

		context.fill()
		context.stroke()

	_colour_by_velocity: (context) ->

		b = if @velocity < @HIGH_VEL then \
			1 - @velocity/@HIGH_VEL else 0
		g = if @velocity < @HIGH_VEL then \
			@velocity/@HIGH_VEL     else 1

		B1 = Math.floor 255*b
		B2 = Math.floor 200 + 55*b

		G1 = Math.floor 255*g
		G2 = Math.floor 200 + 55*g

		context.strokeStyle = 'rgb(0,'+G1+','+B1+')'
		context.fillStyle = 'rgb(200,'+G2+','+B2+')'