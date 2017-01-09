Matter = require "matter-js"
Game = require "../../../Game"

# Yo dawg I heard you like parent directories so I...
Lib = require "../../../Lib"
Geo = Lib.Geo

WeaponFactory = require "../WeaponFactory"
resources = require "../resources"

# Get weapon factory
weapons = WeaponFactory()

class BaseWeaponItem extends Game.Entities.BaseEntityItem
	get_weapon: () -> @weapon
	setup: () ->
		@isSpawned = true
		@lastTime = 0
		@waitTime = 30*1000
	update: (deltaT) ->
		super(deltaT)
		@lastTime += deltaT
		if not @isSpawned
			if @lastTime > @waitTime
				@respawn()
	respawn: () ->
		# Set body mask
		@body.collisionFilter.mask = 1
		# Set visibility
		@isSpawned = true
	despawn: () ->
		# Set body mask
		@body.collisionFilter.mask = 0
		# Set visibility
		@isSpawned = false
		@lastTime = 0
class WeaponItemServer extends BaseWeaponItem
	setup: (@props, @weapon) ->
		super()
	serialize_update: () ->
		data = super()
		Object.assign data,
			props: @props
			isSpawned: @isSpawned
		return data

class WeaponItemClient extends BaseWeaponItem
	setup: (@props, @weapon, @renderable) ->
		super()
	get_renderable: () -> return @
	render: (context) ->
		if @isSpawned
			@renderable.render context
	update: (deltaT) ->
		super(deltaT)
	deserialize_update: (datum) ->
		super datum
		if @isSpawned and not datum.isSpawned
			@despawn()

		if (not @isSpawned) and datum.isSpawned
			@respawn()
		# TODO: Make weapon item spin or something
module.exports = class extends Game.Entities.BaseEntitySF
	# Make server version of the entity
	make_server: (id, props) ->
		wepName = props.weapon
		weapon = weapons.make wepName
		body = @_make_body props
		entity = new WeaponItemServer 'weapon', body, id
		entity.setup props, weapon
		return entity

	# Make client version of the entity
	make_client: (id, props) ->
		wepName = props.weapon
		weapon = weapons.make wepName
		body = @_make_body props
		entity = new WeaponItemClient 'weapon', body, id

		w = weapon.sprite.scale[0]
		h = weapon.sprite.scale[1]
		entity.setup props, weapon,
			new Game.Common.Render.ImageRenderable \
				body, weapon.sprite.location, w, h
		return entity


	_make_body: (props) ->

		# Get position
		x = props.x
		y = props.y

		body = Matter.Bodies.rectangle(x, y, 10, 10)
		Matter.Body.setStatic(body, true)
		return body
