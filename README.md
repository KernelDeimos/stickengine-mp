# StickEngine Multiplayer
An unfinished stick figure game/engine.

![Screenshot](/screenshots/1.png?raw=true)

## Goal
The goal of this project is to create a web-based stickfigure shooter game
that is extremely modular by design. This is made possible by websockets,
HTML5 technologies, and Node.js.

## Running
This has only ever been testing in Linux. If using Windows, you will need to use
a tool like Git Bash for successful installation. If any Windows user tries
this, please post an issue and let me know how it went.

It is also assumed that `npm` is installed.

### The installing/building part
- Run `npm install`
- Make sure browserify and coffeescript are installed globally.
  - `sudo npm install -g browserify`
  - `sudo npm install -g coffeescript`
- Run `./bun` (it's a shell script, /bin/sh)

### The actual running part
- `npm start`
- Open a browser to `http://localhost:3002`

## Status
I started building this about 2years ago, and practically gave up because of how
complicated the project became. I am now putting it online on GitHub.com in hope
that my hard work won't go to waste.

- `tasks.md` contains my todo list from a year ago.
- `doc.md` contains recent documentation I wrote while trying to
           re-learn my source code.

## Contributions
I do intend to slowly try and figure out how to build the game I wanted to. PRs
which are compatible with that mission will be merged.

Please don't modify any files in the `processed` folder. These are generated or
copied from the `source` folder. Most of this game/engine is written in
CoffeeScript, which is harder to understand but requires less typing.

If you rewrite this whole thing in TypeScript with bindings for Matter.js please
let me know, because that would fit the complex architecture of this game/engine
much better.

## Default Ports
- 3002: http
- 8232: websockets
