/*
Specification information:

Type: platform
	data - array containing [x,y,width,height]
*/
var ladderThing3 = 2;
map = {
	'name': "Platform Testing Grounds",
	'objects': [
		{
			'type': 'platform',
			'options': {
				'x': 30,
				'y': 380,
				'w': 200,
				'h': 20
			}
		},


		// Complex platform
		{
			'type': 'jumper',
			'options': {
				'x': 40,
				'y': 60,
				'w': 180,
				'h': 10,
				'velocity': 700
			}
		},
		{
			'type': 'platform',
			'options': {
				'x': 30,
				'y': 70,
				'w': 200,
				'h': 10
			}
		},
		{
			'type': 'platform',
			'options': {
				'x': 30,
				'y': 60,
				'w': 10,
				'h': 10
			}
		},
		{
			'type': 'platform',
			'options': {
				'x': 220,
				'y': 60,
				'w': 10,
				'h': 10
			}
		},

		// L shape 1
		{
			'type': 'platform',
			'options': {
				'x': 200,
				'y': 300,
				'w': 200,
				'h': 20
			}
		},
		{ // The wall on the right
			'type': 'platform',
			'options': {
				'x': 400,
				'y': 120,
				'w': 40,
				'h': 200
			}
		},
		// L shape 2
		{
			'type': 'platform',
			'options': {
				'x': 460,
				'y': 300,
				'w': 200,
				'h': 20
			}
		},
		{ // The wall on the right
			'type': 'platform',
			'options': {
				'x': 660,
				'y': 120,
				'w': 40,
				'h': 180
			}
		},
		// L shape 3
		{
			'type': 'platform',
			'options': {
				'x': 720,
				'y': 300,
				'w': 200,
				'h': 20
			}
		},
		{ // The wall on the right
			'type': 'platform',
			'options': {
				'x': 880,
				'y': 120,
				'w': 40,
				'h': 180
			}
		},
		// L shape 4
		{
			'type': 'platform',
			'options': {
				'x': 460,
				'y': -150,
				'w': 200,
				'h': 20
			}
		},
		{ // The wall on the right
			'type': 'platform',
			'options': {
				'x': 640,
				'y': -400,
				'w': 40,
				'h': 260
			}
		},

		// Jump platform
		{
			'type': 'jumper',
			'options': {
				'x': -200,
				'y': 400,
				'w': 200,
				'h': 20,
				'velocity': 700
			}			
		},

		// Ladder thing
		{
			'type': 'platform',
			'options': {
				'x': -430,
				'y': 380,
				'w': 200,
				'h': 20
			}
		},
		{
			'type': 'platform',
			'options': {
				'x': -431,
				'y': 340,
				'w': 200,
				'h': 20
			}
		},
		// Jump platform
		{
			'type': 'jumper',
			'options': {
				'x': -432,
				'y': 300,
				'w': 200,
				'h': 20,
				'velocity': 1000
			}
		},

		// Ladder thing 2
		{
			'type': 'platform',
			'options': {
				'x': -640,
				'y': 280,
				'w': 200,
				'h': 5
			}
		},
		{
			'type': 'platform',
			'options': {
				'x': -660,
				'y': 270,
				'w': 200,
				'h': 5
			}
		},
		{
			'type': 'platform',
			'options': {
				'x': -680,
				'y': 260,
				'w': 200,
				'h': 5
			}
		},

		// Ladder thing 3
		{
			'type': 'platform',
			'data': {
				'x': -840,
				'y': 250,
				'w': 240,
				'h': 10
			}
		},
		{
			'type': 'platform',
			'data': {
				'x': -880,
				'y': 250-ladderThing3*1,
				'w': 200,
				'h': 10
			}
		},
		{
			'type': 'platform',
			'data': {
				'x': -920,
				'y': 250-ladderThing3*2,
				'w': 200,
				'h': 10
			}
		},
		{
			'type': 'platform',
			'data': {
				'x': -960,
				'y': 250-ladderThing3*3,
				'w': 200,
				'h': 10
			}
		},

		// Floor
		{
			'type': 'jumper',
			'data': {
				'x': -2000,
				'y': 1000,
				'w': 4000,
				'h': 40,
				'velocity': 2000
			},
		},

		// Ceiling
		{
			'type': 'platform',
			'data': {
				'x': -500,
				'y': -600,
				'w': 1600,
				'h': 20
			}
		}
	]
};
// (function(){
// 	var obs = map.objects;

// 	xi = -960;
// 	yi = 244;

// 	s = 20; // step size

// 	// if (true) for (var i=0; i < 500; i++) {
// 	// 	var obj = {
// 	// 		'type': 'jumper',
// 	// 		'data': [xi-i*s,yi-i*s,10,10],
// 	// 		'velocity': 100
// 	// 	};
// 	// 	obs.push(obj);
// 	// }

// 	for (var i=0; i < 10; i++) {
// 		var x = 1050 + 205*i;
// 		// Complex platform
// 		obs.push({
// 			'type': 'jumper',
// 			'data': [x+10,60,180,10],
// 			'velocity': 200*i
// 		});
// 		obs.push({
// 			'type': 'platform',
// 			'data': [x+0,70,200,10]
// 		});
// 		obs.push({
// 			'type': 'platform',
// 			'data': [x+0,60,10,10]
// 		});
// 		obs.push({
// 			'type': 'platform',
// 			'data': [x+190,60,10,10]
// 		});
// 	}
// })();
module.exports = map;
