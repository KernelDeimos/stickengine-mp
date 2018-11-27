Legend
------
- ~ This is a brainstorming point
- : This is a step
- ! This is a note
- : ./ This is a completed task

Tasks
-----

### Later
- Only send modified entities from server
  - ~ Change the entity base class
  - ~ Change stuff that is sent by the server
  - ~ Make some kind of initialization function

### Roadmap
- Move code to game engine
- Create new project repo using game engine
- Fix client/server issues

### Next
- List and repair client sync/initialize
- Do not send platform data to client
- Fix: ghost weapons shown on client init
- Fix: guns of peers not rendering
- Design data awk system at app level
  (I don't remember what this means, but awk means awknowledgement)

### Perhaps (these are undecided)
1. Client entities could be given a "default renderer"
   which is an aggregating renderer that already has
   the chatboxes

### Archive
- Add chat bubbles
  - ~
    - ? How does the client edit chat bubble renderer
      - StickHuman entity can CHAT, can HAVE WEAPON, etc...
      - StickHumanClient implements say()
      - StickHumanClient aggregates ChatBubbleRenderable:q
      <<< IGNORE ALL THIS BELOW I FIGURED IT OUT >>>
      The renderer would be created once an entity is associated
      with a player.
      This happens when player meta is send from the server.
      ServerSync thus needs to add the renderable to its player
      object.
      THE PLAYER WILL MAKE THE RENDERABLE OBJECT
      -> ALL ENTITIES "CAN TALK"
         -> Keeps a RENDERABLE for chat
         -> subclasses responsible for adding it to the
            MAIN RENDERER tag:perhaps.1
      <<< ALT >>>
      Player could have a remove method which calls any listeners
      and whatever created the chatbox could make this listener and
      also make it remove that chatbox so that it can create a chat-
      box that is separate from the entity.
  - : ./ Send player meta to client on connection
  - : <TBD> 
