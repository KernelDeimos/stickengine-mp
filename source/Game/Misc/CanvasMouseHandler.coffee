module.exports = class
	constructor: (@canvas) ->

		@_bind()

		@currentX = 0
		@currentY = 0
		@onClick = () ->

	on_click: (callback) ->
		@onClick = callback

	_bind: () ->
		self = @
		@canvas.addEventListener 'mousemove', (evt) ->
			self._process_event 'move', evt
		@canvas.addEventListener 'mousedown', (evt) ->
			self._process_event 'click', evt

	_process_event: (action, evt) ->
		rect = @canvas.getBoundingClientRect();

		# Thanks K3N on StackOverflow! (#17130395)
		scaleX = @canvas.width  / rect.width;
		scaleY = @canvas.height / rect.height;

		@currentX = (evt.clientX - rect.left) * scaleX;
		@currentY = (evt.clientY - rect.top)  * scaleY;

		if action == 'click'
			@onClick()

	get_coords: () ->
		[@currentX , @currentY]

	get_coordinates: () ->
		x: @currentX
		y: @currentY

# StickEngine.Input.CanvasMouseHandler = function (apiContainer) {
# 	this.apiContainer = apiContainer;
# 	this.canvas = apiContainer.get_canvas();

# 	this._bind();

# 	this.currentX = 0;
# 	this.currentY = 0;

# 	this.onClick = function () {};
# };
# var classn = StickEngine.Input.CanvasMouseHandler;

# classn.prototype.on_click = function(callback) {
# 	this.onClick = callback;
# };

# classn.prototype._bind = function() {
# 	var self = this;

# 	this.apiContainer.get_canvas().addEventListener(
# 		'mousemove',
# 		function (evt) {
# 			self._process_event('move', evt);
# 		}
# 	);

# 	this.apiContainer.get_canvas().addEventListener(
# 		'click',
# 		function (evt) {
# 			self._process_event('click', evt);
# 		}
# 	);
# };

# classn.prototype._process_event = function(action, evt) {
# 	var rect = this.canvas.getBoundingClientRect();

# 	// Thanks K3N on StackOverflow! (#17130395)
# 	var scaleX = this.canvas.width  / rect.width;
# 	var scaleY = this.canvas.height / rect.height;

# 	this.currentX = (evt.clientX - rect.left) * scaleX;
# 	this.currentY = (evt.clientY - rect.top)  * scaleY;

# 	if (action == 'click') {
# 		this.onClick();
# 	}
# };

# classn.prototype.get_coords = function() {
# 	return [
# 		this.currentX,
# 		this.currentY
# 	]
# };

# classn.prototype.get_coordinates = function() {
# 	return {
# 		'x': this.currentX,
# 		'y': this.currentY
# 	}
# };
