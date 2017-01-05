module.exports = class

	constructor: () ->
		@renderAfterList = []
		@renderBeforeList = []

	render_after: (thing) -> @renderAfterList.push thing
	render_before: (thing) -> @renderBeforeList.push thing

	# Abstract method to render the thing
	render: (context) ->
		@_render_list @renderAfterList, context
		@do_render(context)
		@_render_list @renderBeforeList, context
		
	do_render: (context) ->
		console.log "[Warning] This should uhm... " +
			"probably have an implementation."

	_render_list: (list, context) ->
		for renderable in list
			renderable.render context
