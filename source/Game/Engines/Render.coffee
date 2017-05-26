module.exports = class
	constructor: (@canvas, @window) ->
		@renderables = []
		@view_pos =
			x: 0
			y: 0
		@view_size =
			x: @canvas.width
			y: @canvas.height
		@current_fps = 0

	center_camera: (position) ->
		hx = @view_size.x  / 2
		hy = @view_size.y / 2

		@view_pos.x = position.x - hx
		@view_pos.y = position.y - hy

	activate: (@context, @stage) ->
		console.log "Render activated"
		console.log @context
		console.log @stage
		@_bind()
		@_run @window

	_bind: () ->
		self = @

		@stage.on 'stage.add_entity', (entity) ->
			renderable = entity.get_renderable()
			self._add_renderable renderable

		@stage.on 'stage.rem_entity', (entity) ->
			renderable = entity.get_renderable()
			self._rem_renderable renderable

	_add_renderable: (renderable) ->
		@renderables.push renderable

	_rem_renderable: (renderable) ->
		# @renderables.filter (test) -> not (test == renderable)
		for test, i in @renderables
			@renderables.splice i, 1 if test == renderable

	_run: (windowObject) ->
		self = @
		canvas = self.canvas
		context = self.canvas.getContext('2d')

		frameCount = 0
		lastTS = Date.now();
		render = () ->
			# Request frame and increment frame count
			windowObject.requestAnimationFrame(render)
			frameCount++

			# After 20 frames, calculate new FPS
			if frameCount > 20
				frameCount = 0
				ts = Date.now()
				deltaT = ts - lastTS
				lastTS = ts
				@current_fps = 20000 / deltaT

				windowObject.fps = @current_fps

			# Clear canvas
			context.fillStyle = '#fff';
			context.fillRect 0, 0,
				self.canvas.width, self.canvas.height

			# Translate canvas
			context.save()
			context.translate -self.view_pos.x, -self.view_pos.y

			# Render everything				
			for i in [0...self.renderables.length]
				self.renderables[i].render(context)

			# Restore canvas state
			context.restore()
		render()