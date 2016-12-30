StickTreeAnimator = function (
	stickTree,
	animationData
) {
	// Define enumerated values
	this.SIGNAL_NONE   = 0;
	this.SIGNAL_START  = 1;
	this.SIGNAL_STOP   = 2;
	this.SIGNAL_RESET  = 3;
	this.SIGNAL_RESUME = 4;

	// Add objects to instance
	this.stickTree     = stickTree;
	this.animationData = animationData;

	// Initialize defaults
	this.timeElapsed = 0;

	// Define storage
	this.trackersMap  = {}; // for setting
	this.trackersList = []; // for processing

	// Loop through all animations
	for (var anim in this.animationData)
	if (this.animationData.hasOwnProperty(anim)) {
		// Create object to track animation state
		var trackingObject = {
			'name':     anim,
			'data':     this.animationData[anim],
			'running':  false,
			'signal':   this.SIGNAL_NONE,
			'position': 0
		}
		// Register tracking object to map and list
		this.trackersMap[anim] = trackingObject;
		this.trackersList.push(trackingObject);
		// Ensure animations are processed in order
		this.trackersList.sort(function(ta, tb) {
			return ta.data.order - tb.data.order;
		});
	}
};
var classn = StickTreeAnimator;

classn.prototype.increment_clock = function(time_ms) {
	this.timeElapsed = time_ms;
};

/**
 * This method sends a signal to begin processing
 * of an animation.
 *
 * @param  animationName  name of the animation
 * @throws  key error if animation is not found
 */
classn.prototype.start_animation = function(animationName) {
	var tracker = this.trackersMap[animationName];
	tracker.signal = this.SIGNAL_RESUME;
};

/**
 * This method sends a signal to stop processing
 * of an animation.
 *
 * @param  animationName  name of the animation
 * @throws  key error if animation is not found
 */
classn.prototype.stop_animation  = function(animationName) {
	var tracker = this.trackersMap[animationName];
	tracker.signal = this.SIGNAL_STOP;
};

classn.prototype.check_animation = function(animationName) {
	var tracker = this.trackersMap[animationName];
	return tracker.running;
};

classn.prototype.process = function() {
	var self = this; // callbacks are used

	// Grab elapsed time and reset counter
	var timeElapsed = self.timeElapsed;
	self.timeElapsed = 0;

	// Loop through animation trackers
	self.trackersList.map(function (tracker) {
		// Note if animation is already running
		var doRun = tracker.running;

		// Check for signals
		var sig = tracker.signal;
		if (sig !== self.SIGNAL_NONE) {
			// Handle known signal cases
			if (sig === self.SIGNAL_START) {
				// Apply start position
				self.run_instant_actions(
					tracker.data.reset
				);
				//
				tracker.position = 0;
				tracker.running = true;
			}
			else if (sig === self.SIGNAL_RESUME) {
				tracker.running = true;
			}
			else if (sig === self.SIGNAL_STOP) {
				// Stop future running, and do not run now
				tracker.running = false;
				doRun = false;
			}
			else if (sig === self.SIGNAL_RESET) {
				throw "SIGNAL_RESET is not yet implemented";
			}
			// Remove signal from tracker
			tracker.signal = self.SIGNAL_NONE;
		}

		// Maybe run animation
		if (doRun) {
			// Update animation time
			tracker.position += timeElapsed;

			// Loop or terminate animation if duration is exceeded
			if (tracker.position > tracker.data.duration) {
				// Check loop parameter
				if (tracker.data.loop == false) {
					// Stop future running
					tracker.running = false;
				}
				// Loop animation
				else {
					// Reset limbs if required
					if (tracker.data.autoReset) {
						self.run_instant_actions(
							tracker.data.reset
						);
					}
					// Wraparound position value
					tracker.position
						= tracker.position % tracker.data.duration;
				}
			}
			// Ensure still running
			if (tracker.running) {
				// Perform actions
				self.run_linear_actions(tracker, tracker.data.steps);
			}
		}
	});
};

classn.prototype.run_instant_actions = function(actionList) {
	var self = this; // callbacks are used

	actionList.map(function (actionGroup) {
		// Localize instruction parts
		var limb   = actionGroup[0];
		var action = actionGroup[1];
		var param  = actionGroup[2];

		// Get limb object, then get limb's Geo.Line object
		var lo = self.stickTree.get_limb_by_name(limb);
		var line = lo.get_line();

		// Perform action
		if (action == "setangle") {
			// Set angle on line
			line.set_angle(param /*radians*/);
		} else {
			throw "Action '"+action+"' does not exist!";
		}
	});
};

classn.prototype.run_linear_actions = function(tracker, actionList) {
	var self = this; // callbacks are used

	// Define closure for performing an action
	var perform_action = function (position, st, actionListItem) {
		// Localize values in action
		var length = actionListItem[0]; // units of ms
		var limb   = actionListItem[1];
		var action = actionListItem[2];

		// Get limb object, then get limb's Geo.Line object
		var lo = self.stickTree.get_limb_by_name(limb);
		var line = lo.get_line();

		// Perform action
		if (action == "turnto") {
			// Localize parameters
			var direction  = (actionListItem[3]=='cw')?1:-1;
			var end_angle  = actionListItem[4];

			// Calculate end position (in time) of animation
			var et = st + length; // end time
			// If the action has already ended, apply full value
			if (position >= et) {
				line.set_angle(end_angle /*radians*/);
			}
			// Otherwise, calculate linear change
			// TW: Math
			else {
				// Localize target angles, calculate difference
				var start_angle = line.get_angle();
				// Calculation motion range
				var diff_angle = end_angle - start_angle;
				if (diff_angle*direction < 0) diff_angle += 2*Math.PI;
				// Calculation transitional angle
				var fraction = (position - st) / length;
				var a = start_angle + diff_angle*fraction;
				a = a % (2*Math.PI);
				// Apply calculated angle!
				line.set_angle(a);
			}
		} else {
			throw "Action '"+action+"' does not exist!";
		}
	}

	// Get current animation position
	var position = tracker.position;

	// Loop through and apply animation actions
	actionList.map(function (actionPosition) {
		var st = actionPosition[0]; // start time
		if (st <= position) { // check if action is effective

			// Loop through actions in this position
			actionPosition[1].map(function (actionListItem) {
				perform_action(position, st, actionListItem);
			});

			
		}
	});
};

module.exports = classn;
