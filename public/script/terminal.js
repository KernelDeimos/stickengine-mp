function TerminalGUI() {
	var self = this;
	self.console = null;
	self._bind();
}

TerminalGUI.prototype._bind = function() {
	var self = this;

	self.termElem = $('#term');
	self.term = window.term;

	// Handle new console
	term.on('new_game', function (console, game) {
		self.console = console;
		self.game = game;
		self._listen();
	});

	// Handle keypress
	$(window).keypress(function (evt) {
		self.handle_keypress(evt);
	});
};

/** Listen for console messages */
TerminalGUI.prototype._listen = function() {
	var self = this;
	self.console.on('ouput', function (message) {
		var outbox = self.termElem.find('.contents');
		outbox.append(
			message
		);
		outbox.animate({
			scrollTop: outbox[0].scrollHeight
		}, 200);
	})
};

TerminalGUI.prototype.handle_keypress = function(evt) {
	var self = this;
	if (self.console == null) return;

	var game = self.game;
	var cons = self.console;
	var termElem = self.termElem;

	if (evt.which == 96 || evt.which == 126) {
		// If we're going to show the terminal
		if (termElem.is(':hidden')) {
			// Ignore inputs and focus terminal
			if (game != null) game.ignore_inputs();
			termElem.slideToggle(200)
			termElem.find('.input').first().focus();
		}
		// If we're going to hide the terminal
		else {
			// Re-enable game inputs and blur terminal
			if (game != null) game.accept_inputs();
			termElem.slideToggle(200)
			termElem.find('.input').first().blur();
		}

		// Don't propogate '`' to terminal input
		evt.preventDefault();
		return false;
	}
	else
	// If enter key pressed
	if (evt.which == 13) {
		if (termElem.is(':visible')) {
			// Send input to game
			inputO = termElem.find('.input');
			input = inputO.html();
			inputO.html('');
			cons.enter_command(input);
		}
		// Don't propogate "\n" to terminal input
		evt.preventDefault();
		return false;
	}
};

$(document).ready(function () {
	var when_script_loaded = function () {
		// The client.coffee script should have added
		// globals before this is run, but technically
		// there is no guarentee - try again later if
		// the window.menu global is missing.
		if (typeof window.menu === 'undefined') {
			setTimeout(function () {
				when_script_loaded();
			}, 500);
			return;
		}

		new TerminalGUI();
	};
	when_script_loaded();
});
/*
window.on_game_ready = function () {
	var term = $('#term');
	var c = window.game.get_console();
	c.on('ouput', function (message) {
		var outbox = term.find('.contents');
		outbox.append(
			message
		);
		outbox.animate({
			scrollTop: outbox[0].scrollHeight
		}, 200);
	});
};

$(window).keypress(function (evt) {
	var term = $('#term');
	var cons = null;
	game = window.game
	if (game != null) cons = game.get_console();
	// If console key pressed
	if (evt.which == 96 || evt.which == 126) {
		// If we're going to show the terminal
		if (term.is(':hidden')) {
			// Don't show terminal if game isn't running
			if (game == null) return
			// Ignore inputs and focus terminal
			window.game.ignore_inputs();
			term.slideToggle(200)
			term.find('.input').first().focus();
		}
		// If we're going to hide the terminal
		else {
			// Re-enable game inputs and blur terminal
			if (game != null) window.game.accept_inputs();
			term.slideToggle(200)
			term.find('.input').first().blur();
		}

		// Don't propogate '`' to terminal input
		evt.preventDefault();
		return false;
	}
	else
	// If enter key pressed
	if (evt.which == 13) {
		if (term.is(':visible')) {
			// Don't send input if game isn't running
			if (game == null) return
			// Send input to game
			inputO = term.find('.input')
			input = inputO.html();
			inputO.html('');
			cons.enter_command(input)

		}

		// Don't propogate "\n" to terminal input
		evt.preventDefault();
		return false;
	}

})
*/