Bodies = (require "matter-js").Bodies
Body = (require "matter-js").Body
Game = require "../../../Game"

# Yo dawg I heard you like parent directories so I...
Lib = require "../../../Lib"
Geo = Lib.Geo

# Objects / Controllers
StickTree = require "../StickTree"
StickTreeRenderer = require "../StickTreeRenderer"
StickTreeAnimator = require "../StickTreeAnimator"

# Data
Data = require "../Data"

class StickHumanAbstract extends Game.Entities.BaseEntityCreature

	setup: () ->
		@animation = 'none'

		@on 'receive_item.weapon', (weapon, next) ->
			console.log "Got weapon!"
			console.log weapon
			# Inform item that this was handled
			next()

	serialize_update: () ->
		data = super()
		Object.assign data,
			animation: @animation
		return data


class StickHumanServer extends StickHumanAbstract

	walk: (direction) ->
		super direction
		if direction == 'left'
			@animation = 'left'
		else if direction == 'right'
			@animation = 'right'
		else
			@animation = 'none'


class StickHumanClient extends StickHumanAbstract

	setup: (
		@renderable, @animable
		@talkbubble, @nametag, @weaponrender
	) ->
		super()
		@on 'receive_item.weapon', (weapon, next) ->
			# Create renderable for weapon
			sprite = weapon.sprite
			render = new Game.Common.Render.ImageRenderable \
				@body, sprite.location, sprite.scale[0],
				sprite.scale[1]
			@weaponrender.set_renderable render

	get_renderable: () -> return @renderable

	say: (text) -> @talkbubble.show_message text

	set_name: (text) -> @nametag.set_text text

	# --- for animations...

	deserialize_update: (datum) ->
		super datum
		if datum.animation != @animation
			console.log "CHANGE ANIM"
			if datum.animation == 'left'
				@animable.stop_animation  'walk_right'
				@animable.start_animation 'walk_left'
			else if datum.animation == 'right'
				@animable.stop_animation  'walk_left'
				@animable.start_animation 'walk_right'
			else
				@animable.stop_animation  'walk_right'
				@animable.stop_animation  'walk_left'
			@animation = datum.animation

	update: (deltaT) ->
		super deltaT
		# Update talk bubble
		@talkbubble.update deltaT
		# Update animation
		@animable.increment_clock(deltaT)
		@animable.process()

	walk: (direction) ->
		super direction
		if direction == 'left'
			@animable.stop_animation  'walk_right'
			@animable.start_animation 'walk_left'
			@animation = 'left'
		else if direction == 'right'
			@animable.stop_animation  'walk_left'
			@animable.start_animation 'walk_right'
			@animation = 'right'
		else
			@animable.stop_animation  'walk_right'
			@animable.stop_animation  'walk_left'
			@animation = 'none'


module.exports = class extends Game.Entities.BaseEntitySF
	# Make server version of the entity
	make_server: (id, props) ->
		body = @_make_body()
		entity = new StickHumanServer('stickhuman', body, id)
		entity.setup()
		return entity

	# Make client version of the entity
	make_client: (id, props) ->
		body = @_make_body()
		tree = @_make_tree body

		renderable = new StickTreeRenderer tree
		animable = new StickTreeAnimator tree, Data.Animation.StickHuman
		nametag = new Game.Common.Render.NameTag body, 85
		talkbubble = new Game.Common.Render.TalkBubble body, 100

		weaponrender = new Game.Common.Render.StateRenderable null

		# Add the talk bubble to the main renderable
		renderable.render_before talkbubble
		renderable.render_before nametag
		renderable.render_before weaponrender

		entity = new StickHumanClient('stickhuman', body, id)
		entity.setup renderable, animable,
			talkbubble, nametag, weaponrender
		return entity

	_make_body: () ->
		body = Bodies.rectangle(0, 0, 20, 140)
		Lib.Body.set_can_rotate(body, false)
		return body

	_make_tree: (body) ->

		geoBodyPlugin =
			get_position: () -> body.position

		pos = new Geo.RelCoord(geoBodyPlugin, 0, 3)

		root   = pos.make_relative()
		collar = root.make_relative()
		chin   = collar.make_relative()
		top    = chin.make_relative()

		elbow = []
		hand  = []
		knee  = []
		foot  = []

		elbow[0] = collar.make_relative()
		elbow[1] = collar.make_relative()
		hand[0]  = elbow[0].make_relative()
		hand[1]  = elbow[1].make_relative()
		knee[0]  = root.make_relative()
		knee[1]  = root.make_relative()
		foot[0]  = knee[0].make_relative()
		foot[1]  = knee[1].make_relative()

		stickTree = new StickTree();

		stickTree.register_limb(
			'body',
			'line',
			new Geo.Line(collar, 40, -0.5*Math.PI)
		)
		stickTree.register_limb(
			'neck',
			'line',
			new Geo.Line(chin, 10, -0.5*Math.PI)
		)
		stickTree.register_limb(
			'head',
			'circle',
			new Geo.Line(top, 24, -0.5*Math.PI)
		).set_type('circle')

		for s in [0..1]
			console.log s
			sign = if s==0 then +1     else -1;
			side = if s==0 then 'left' else 'right';

			a1 = (0.5 + 0.25*sign) * Math.PI;
			a2 = (0.5 + 0.10*sign) * Math.PI;
			a3 = (0.5 + 0.15*sign) * Math.PI;
			a4 = (0.5 + 0.05*sign) * Math.PI;

			stickTree.register_limb(
				side+'_upper_arm',
				'line',
				new Geo.Line(elbow[s], 32, a1)
			)

			stickTree.register_limb(
				side+'_lower_arm',
				'line',
				new Geo.Line(hand[s], 32, a2)
			)
			
			stickTree.register_limb(
				side+'_upper_leg',
				'line',
				new Geo.Line(knee[s], 36, a3)
			)
			
			stickTree.register_limb(
				side+'_lower_leg',
				'line',
				new Geo.Line(foot[s], 36, a4)
			)

		return stickTree;
