module.exports =
	remove_from_list: (item, list) ->
		list.filter (test) -> test isnt item
