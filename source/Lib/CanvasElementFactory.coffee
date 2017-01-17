# This is a static-method factory.
# Such a factory should be sufficient for this purpose;
# if the method of creating canvases must be changed at
# runtime, a setup() method could be added

module.exports =
	make_canvas: (w,h) ->
		can = document.createElement 'canvas'
		can.width = w
		can.height = h
		return can
	make_context: (w, h) ->
		can = @make_canvas w, h
		return can.getContext '2d'
