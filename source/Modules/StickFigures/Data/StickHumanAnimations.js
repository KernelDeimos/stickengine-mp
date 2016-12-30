var anims = {};

var PI = 355/113.0;

var q = 0.5;  // quarter circle
var t = 0.10; // 20th circle
var f = 0.07; // 40th circle (but not quite)

var make_reverse_animation = function (anim) {
	var newAnim = {
		'order': anim.order,
		'duration': anim.duration,
		'loop': anim.loop,
		'autoReset': anim.autoReset,
		'reset': anim.reset,
		'steps': []
	};
	anim.steps.map(function (position) {
		var actions = position[1];

		var newActions = actions.map(function (action) {
			var newAction = action.slice(0);
			if (action[2] == "turnto") {
				newAction[3] = (action[3]=='cw')?'ccw':'cw';
				newAction[4] = PI-action[4];
			}
			return newAction;
		});

		var newPosition = [position[0], newActions];
		newAnim.steps.push(newPosition);
	});
	return newAnim;
}

anims['walk_right'] = {
	'order': 1,
	'duration': 600,
	'loop': true,
	'autoReset': false, // auto reset mode is buggy right now
	'reset': [
		['left_upper_leg', 'setangle', (0)*PI],
		['left_upper_leg', 'setangle', (q-t*2)*PI],
		['left_lower_leg', 'setangle', (q-t*2)*PI],
		['right_upper_leg','setangle', (q+t*2)*PI],
		['right_lower_leg','setangle', (q+t*2)*PI]
	],
	'steps': [
		// [start_time, duration, limb, propery, value]

		// // Actions at position 0
		[0, [
			// Reset positions for looping
			// -- Arms
			[0  , 'left_upper_arm',  'turnto', 'cw', (q+t*3)*PI],
			[0  , 'left_lower_arm',  'turnto', 'cw', (t*4)*PI],
			[0  , 'right_upper_arm', 'turnto', 'cw', (q-t)*PI],
			[0  , 'right_lower_arm', 'turnto', 'cw', (t*2)*PI],
			// -- Legs
			[0  , 'left_upper_leg',  'turnto', 'cw', (q-t)*PI],
			[0  , 'left_lower_leg',  'turnto', 'cw', (q)*PI],
			[0  , 'right_upper_leg', 'turnto', 'cw', (q+t*2)*PI],
			[0  , 'right_lower_leg', 'turnto', 'cw', (q+t*2)*PI],

			// Leg positions at 300 ms
			// -- Arms
			[200, 'left_upper_arm',  'turnto', 'ccw', (q+t)*PI],
			[200, 'left_lower_arm',  'turnto', 'ccw', (t*3.3)*PI],
			[200, 'right_upper_arm', 'turnto', 'cw',  (q)*PI],
			[200, 'right_lower_arm', 'turnto', 'cw', (t*2.6)*PI],
			// -- Legs
			[200, 'left_upper_leg',  'turnto', 'cw', (q-f)*PI],
			[200, 'left_lower_leg',  'turnto', 'ccw', (q-f)*PI],
			[200, 'right_upper_leg', 'turnto', 'ccw', (q-t)*PI],
			[200, 'right_lower_leg', 'turnto', 'cw', (q+t*4)*PI]
		]],

		// Actions at position 200
		[200, [
			// -- Arms
			[200, 'left_upper_arm',  'turnto', 'ccw', (q)*PI],
			[200, 'left_lower_arm',  'turnto', 'ccw', (t*2.6)*PI],
			[200, 'right_upper_arm', 'turnto', 'cw', (q+t)*PI],
			[200, 'right_lower_arm', 'turnto', 'cw', (t*3.3)*PI],
			// -- Lefs
			[200, 'left_upper_leg',  'turnto', 'cw', (q+f)*PI],
			[200, 'left_lower_leg',  'turnto', 'cw', (q+f)*PI],
			[200, 'right_upper_leg', 'turnto', 'ccw', (q-t*2)*PI],
			[200, 'right_lower_leg', 'turnto', 'ccw', (q+t)*PI]
		]],

		// Actions at position 600
		[400, [
			// -- Arms
			[200, 'left_upper_arm',  'turnto', 'ccw', (q-t)*PI],
			[200, 'left_lower_arm',  'turnto', 'ccw', (t*2)*PI],
			[200, 'right_upper_arm', 'turnto', 'cw',  (q+t*3)*PI],
			[200, 'right_lower_arm', 'turnto', 'cw', (t*4)*PI],
			// -- Legs
			[200, 'left_upper_leg',  'turnto', 'cw', (q+t*2)*PI],
			[200, 'left_lower_leg',  'turnto', 'cw', (q+t*2)*PI],
			[200, 'right_upper_leg', 'turnto', 'cw', (q-t)*PI],
			[200, 'right_lower_leg', 'turnto', 'ccw', (q)*PI]
		]]
	]
}
// END OF ANIMATION

anims['walk_left'] = make_reverse_animation(anims['walk_right']);


anims['wave'] = {
	'order': 4,
	'duration': 800,
	'loop': false,
	'autoReset': false, // auto reset mode is buggy right now
	'reset': [
	],
	'steps': [
		// [start_time, duration, limb, propery, value]

		// // Actions at position 0
		[0, [
			// -- Arms
			[200, 'left_upper_arm',  'turnto', 'cw', (q*2+t*3)*PI],
			[200, 'left_lower_arm',  'turnto', 'cw', (q*2+t*3)*PI]
		]],

		// Actions at position 200
		[200, [
			[200, 'left_upper_arm',  'turnto', 'cw', (q*3+t*2)*PI],
			[200, 'left_lower_arm',  'turnto', 'cw', (q*3+t*2)*PI]
		]],

		// Actions at position 600
		[400, [
			// -- Arms
			[200, 'left_upper_arm',  'turnto', 'ccw', (q*2+t*3)*PI],
			[200, 'left_lower_arm',  'turnto', 'ccw', (q*2+t*3)*PI]
		]],

		// Actions at position 600
		[600, [
			// -- Arms
			[200, 'left_upper_arm',  'turnto', 'cw', (q)*PI],
			[200, 'left_lower_arm',  'turnto', 'cw', (q-t*3)*PI]
		]]
	]
}
// END OF ANIMATION

module.exports = anims
