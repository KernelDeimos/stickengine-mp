// Ext libraries
var urlModule = require('url');
var readline = require('readline');

var server_init = require('./processed/server');

module.exports = function(options) {

	// Create commandline interface
	rl = readline.createInterface({
		input: process.stdin,
		output: process.stdout,
		prompt: 'ServerGM> '
	})

	// Create the logging function
	logger = function (message) {
		process.stdout.clearLine()
		process.stdout.cursorTo(0)
		console.log(message)
		rl.prompt(true)
	}

	// Start server
	console.log('Starting Server...')
	var WebSocketServer = require('ws').Server;
	var wss = new WebSocketServer(options);

	server_init(wss,logger);
	// serverGM = new Server(wss, logger)
	// serverGM.run()

	// Run first prompt
	rl.prompt()

	setTimeout(function () {
		logger("This is a test")
	}, 2000)

	rl.on('line', function (line) {
		line = line.trim()
		serverGM.process_input(line)

		rl.prompt()
	})
};
