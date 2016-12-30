/**
 * Describes a map of "limbs" for a stick creature, their properties,
 * and their angles. Any colour or style changes applied to limbs of
 * an instance of a stick creature will be stored here. The
 * information will be used by the renderer and collision detector.
 *
 * A limb is composed of a Geo.Line, a type, and other properties.
 */
StickTree = function () {
	/* Note:
	using a map+list structure here because it offers the
	fastest retrieval of limb by name or all limbs. Removal
	now takes O(n) time but removal will rarely happen.
	*/
	this.limbs_map = {};
	this.limbs_list = [];

	this.Limb = function (name, type, line) {
		this.props = {};
		this.name = name;
		this.type = type;
		this.line = line;
	}

	this.Limb.prototype.set = function(key, val) {
		this.props[key] = val;
	};
	this.Limb.prototype.get = function(key) {
		if (this.props.hasOwnProperty(key)) {
			return this.props[key];
		}
		return null;
	};

	this.Limb.prototype.set_type = function(type) {
		this.type = type;
	};
	this.Limb.prototype.get_type = function() {
		return this.type;
	};

	this.Limb.prototype.get_line = function() {
		return this.line;
	};
}
var classn = StickTree;

/* Specification
Stick tree objects:
{
	name,
	type,
	line,
	... additional properties ...
}
*/

classn.prototype.register_limb = function(name, type, line) {
	// Create limb object
	var limb = new this.Limb(name, type, line);
	// Register limb in map
	this.limbs_map[name] = limb;
	this.limbs_list.push(limb);
	// return the limb object
	return limb;
};

classn.prototype.get_limbs = function(name, type, line) {
	// Return the limbs list
	return this.limbs_list;
};


classn.prototype.get_limb_by_name = function(name, type, line) {
	// Locate and return the limb object
	return this.limbs_map[name];
};

module.exports = StickTree;
