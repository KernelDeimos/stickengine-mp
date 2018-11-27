# Stickfigure Engine Doc

### Weapons

#### Defined under `source/Modules/Weapons`
Behaviour of weapons, and some default weapons.
The index file in this directory defines a BaseModule with an install function.

Install steps:
-   Add all entities under ./Entities/index
-   Add all actions  under ./Actions/index
-   Add a trigger for `stage.add_entity.weapon`

This directory also includes a WeaponFactory class. This is not provided to the
game engine, but rather used by WeaponItem entities (the ones that show up on
the map) to create a weapon object which will be given to the player on
collision via an event called `receive_item.weapon`.

The logic in the stickfigure entity itself (defined under
`source/Modules/StickFigures`) is responsible for then using the weapon object
to render a weapon in the figure's hand and calling the weapon's "fire" method.

TODO: Add player UUID as parameter of fire method
TODO: Is the weapon object different on servers?

##### Note to Self:
Okay, I figured it out. The weapons module DOES need to make the weapons factory
available to the game engine. This way, the server can send clients serialized
information about how to create a weapon object for the client, which can be
recieved by stickfigure entities.

Also, a player recieving a weapon and the respective entity recieving a weapon
need to be two different things. Or I guess, any event affecting an entity will
be able to be handled also by a player, so that's probably a trivial problem to
solve.

- The client figure's receive_item.weapon needs to recieve not a weapon object,
  but instructions on how to construct a weapon renderable which it can pass to
  the shared weapon factory to get a renderable to place in the figure's hand.
