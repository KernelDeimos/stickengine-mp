function firstof(/**/)
{
	var values = arguments;

	for (var i=0; i<values.length; i++) {
		if (typeof values[i] !== 'undefined') {
			return values[i];
		}
	}

	return undefined;
}

/**
 * This class sets the position of a relative coordinate based on the
 * length and angle of a line.
 * This class does not necessarily represent a rendered line, but it
 * is used to determine the end points of a rendered line.
 */
Line = function (position, length, angle)
{
	this.position = position;
	this.length = firstof(length, 1);
	this.angle = firstof(angle, 0);
};
var classn = Line;
/**
 * @param  angle  angle of the line an radians
 */
classn.prototype.set_angle = function(angle) {
	this.angle = angle;

	return this; // for chaining
};
classn.prototype.get_angle = function() {
	return this.angle;
};
classn.prototype.update = function() {
	// Calculate x and y coords with trig
	var x = this.length*Math.cos(this.angle);
	var y = this.length*Math.sin(this.angle);
	// Update relative position
	this.position.set_position(x,y);

	return this; // for chaining
};

classn.prototype.get_node = function() {
	return this.position;
};

classn.prototype.get_length = function() {
	return this.length;
};

module.exports = Line;
