# This class renders a Matter-JS body.
module.exports = class
	constructor: (@body, @fill=null) ->
	render: (context) ->
		context.beginPath()

		vertices = @body.vertices;

		context.moveTo(0,0);
		pos = @body.position;

		context.moveTo(vertices[0].x, vertices[0].y);

		for j in [1...vertices.length]
			context.lineTo(vertices[j].x, vertices[j].y);

		context.lineTo(vertices[0].x, vertices[0].y);

		context.lineWidth = 2;
		context.strokeStyle = '#999';
		context.closePath();
		if (@fill != null)
			context.fillStyle = @fill
			context.fill();
		context.stroke();
