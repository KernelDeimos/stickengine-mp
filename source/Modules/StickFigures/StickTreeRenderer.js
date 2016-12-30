/**
 * Renders a stick tree object onto a canvas context.
 */
StickTreeRenderer = function(stickTree)
{
	this.stickTree = stickTree;
}
var classn = StickTreeRenderer;

classn.prototype.render = function(context) {
	var self = this; // callbacks are used

	// Get list of limbs
	var limbs = self.stickTree.get_limbs();
	limbs.map(function (limb) {
		// Draw limb
		self.draw_limb(context, limb);
	});
};

classn.prototype.draw_limb = function(context, limb) {
	
	// Localize important limb information
	var line = limb.get_line();
	var type = limb.get_type();
	var thick = limb.get('thickness');
	if (thick === null) thick = 2;

	// Update line coordinates for drawing
	line.update();

	if (type == 'line') {
		context.beginPath();

		// Get endpoints of line
		var pos = line.get_node();
		var spos = pos.get_reference();
		var epos = pos.get_position();

		// Draw line
		context.moveTo(spos.x, spos.y);
		context.lineTo(epos.x, epos.y);
		context.lineWidth = this.thickness;
		context.strokeStyle = "rgb(0,0,0)";
		context.stroke();
	}

	else if (type == 'circle') {

		context.beginPath();

		// Get endpoints of line
		var pos = line.get_node();
		var spos = pos.get_reference();
		var epos = pos.get_position();

		var cx = (spos.x + epos.x) / 2.0;
		var cy = (spos.y + epos.y) / 2.0;
		var r = line.get_length() / 2.0;

		context.arc(cx, cy, r, 0, 2*Math.PI);
		context.lineWidth = thick;
		context.strokeStyle = "rgb(0,0,0)";
		context.stroke();
	}
};

module.exports = classn;
