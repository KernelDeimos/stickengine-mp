Game = require "../../Game"
Renderable = Game.Common.Abstract.Renderable

# Renders a stick tree object onto a canvas context.
module.exports = class extends Renderable
	constructor: (@stickTree) ->
		super()
	do_render: (context) ->
		limbs = @stickTree.get_limbs()

		self = @
		limbs.map (limb) ->
			self.draw_limb context, limb
	draw_limb: (context, limb) ->
		line = limb.get_line();
		type = limb.get_type();
		thick = limb.get('thickness');
		if thick == null then thick = 2;

		# Update line coordinates for drawing
		line.update()

		if type == 'line'
			context.beginPath()

			# Get endpoints of line
			pos = line.get_node()
			spos = pos.get_reference()
			epos = pos.get_position()

			# Draw line
			context.moveTo(spos.x, spos.y)
			context.lineTo(epos.x, epos.y)
			context.lineWidth = thick
			context.strokeStyle = "rgb(0,0,0)"
			context.stroke()

		else if type == 'circle'

			context.beginPath()

			# Get endpoints of line
			pos = line.get_node()
			spos = pos.get_reference()
			epos = pos.get_position()

			cx = (spos.x + epos.x) / 2.0
			cy = (spos.y + epos.y) / 2.0
			r = line.get_length() / 2.0

			context.arc(cx, cy, r, 0, 2*Math.PI)
			context.lineWidth = thick
			context.strokeStyle = "rgb(0,0,0)"
			context.stroke()

