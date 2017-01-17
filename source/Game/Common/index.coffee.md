Common Classes
==============

This module contains common classes that any game module may use.

	module.exports =
		Abstract:
			Renderable: require "./Abstract/Renderable"
		Render:
			StateRenderable: require "./Render/StateRenderable"

			BodyRenderable: require "./Render/BodyRenderable"
			ImageRenderable: require "./Render/ImageRenderable"
			SpriteRenderable: require "./Render/SpriteRenderable"

			TalkBubble: require "./Render/TalkBubble"
			NameTag: require "./Render/NameTag"
