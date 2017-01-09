Common Classes
==============

This module contains common classes that any game module may use.

	module.exports =
		Abstract:
			Renderable: require "./Abstract/Renderable"
		Render:
			BodyRenderable: require "./Render/BodyRenderable"
			ImageRenderable: require "./Render/ImageRenderable"
			StateRenderable: require "./Render/StateRenderable"
			TalkBubble: require "./Render/TalkBubble"
			NameTag: require "./Render/NameTag"
