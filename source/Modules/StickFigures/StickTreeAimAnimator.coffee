 
# Similar to the StickTreeAnimator, but instead of running animation data
# it aims the arms based on a given angle value.

module.exports = class
	constructor: (@stickTree, @weaponRender) ->
		@hands = 2
		@active = false

	activate: () -> @active = true
	deactivate: () -> @active = false

	process: (angle) ->
		if not @active then return

		bend1 = [2.1,0.2]
		bend2 = [1.4,0.4]

		if angle > Math.PI/2
			bend1 = (
				for x in bend1
					-x
			)
			bend2 = (
				for x in bend2
					-x
			)

		top = @stickTree.get_limb_by_name 'left_upper_arm'
		top = top.get_line()
		bot = @stickTree.get_limb_by_name 'left_lower_arm'
		bot = bot.get_line()
		top.set_angle angle+bend1[0]
		bot.set_angle angle-bend1[1]

		if @hands == 2
			top = @stickTree.get_limb_by_name 'right_upper_arm'
			top = top.get_line()
			bot = @stickTree.get_limb_by_name 'right_lower_arm'
			bot = bot.get_line()
			top.set_angle angle+bend2[0]
			bot.set_angle angle-bend2[1]
