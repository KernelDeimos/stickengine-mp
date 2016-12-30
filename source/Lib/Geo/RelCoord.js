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

RelCoord = function (parent, dx, dy)
{
	this.parent = firstof(parent, null);
	this.dx     = firstof(dx,     0);
	this.dy     = firstof(dy,     0);
};

/**
 * Creates a child coordinate relative to this coordinate.
 */
RelCoord.prototype.make_relative = function(dx, dy) {
	var dx = firstof(dx, 0);
	var dy = firstof(dy, 0);
	return new RelCoord(this,dx,dy);
};
/**
 * Attaches this coordinate to a new parent coordinate.
 */
RelCoord.prototype.attach = function(parent) {
	this.parent = parent;
	return this; // for chaining
};

RelCoord.prototype.set_position = function(x, y) {
	this.dx = x;
	this.dy = y;
	return this; // for chaining
};
RelCoord.prototype.move = function(x, y) {
	this.dx += x;
	this.dy += y;
	return this; // for chaining
};
RelCoord.prototype.get_position = function() {
	refpos = {'x':0,'y':0};
	if (this.parent !== null) {
		refpos = this.parent.get_position();
	}
	return {
		'x': refpos.x + this.dx,
		'y': refpos.y + this.dy
	};
};
RelCoord.prototype.get_displacement = function() {
	return {
		'x': this.dx,
		'y': this.dy
	};
};
RelCoord.prototype.get_reference = function() {
	return this.parent.get_position();
};

RelCoord.prototype.get_parent = function() {
	return this.parent;
};

module.exports = RelCoord
