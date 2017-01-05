$(document).ready(function () {

	// Obtain menu from document
	var menu = $("#menu");

	var menu_form_to_data = function (formName) {
		var form = menu.find('.form[data-name='+formName+']').first();

		data = {}
		// JQuery serialize but then convert that to map
		dataInterm = form.serializeArray();
		dataInterm.forEach(function (datum) {
			data[datum.name] = datum.value;
		});

		return data;
	}

	var bind_server_buttons = function () {
		// When server is clicked, send back server index
		menu.find('.server').on('click', function () {
			var item = $(this);

			// Get player name
			var playerName;
			// :: serialize form with name player_guest
			data = menu_form_to_data('player_guest');
			// :: verify that name is present
			if (data.name == '') {
				// :: complain to user and quit
				alert('You gotta type a name first');
				return;
			}
			// :: set player name from form data
			playerName = data.name;

			// Create data object

			data = {
				action: 'join',
				index: item.find('input[name=index]').first().val(),
				guest: playerName
			}

			// Invoke the game client's menu interface
			window.menu.emit('do', data);
		})
	}

	var bind_menu = function () {
		// The client.coffee script should have added
		// globals before this is run, but technically
		// there is no guarentee - try again later if
		// the window.menu global is missing.
		if (typeof window.menu === 'undefined') {
			setTimeout(function () {
				bind_menu();
			}, 500);
			return;
		}

		// Make [Enter] on buttons also trigger click
		// IMO, JQuery's click should have a special
		// case for <button>s so that Enter works...
		menu.find('button, .button').each(function () {
			$(this).on('keydown', function (e) {
				if (e.which == 13) {
					this.click();
					return false;
				}
			});
		});

		// Function for when .sw elements are clicked
		var switch_screen = function (scrn_name) {
			menu.find('.screen').each(function () {
				elem = $(this);
				if (elem.data('name') == scrn_name) {
					elem.show();
					elem.find('.form').first()
						.find('.entry').first()
						.find('input').first()
						.focus();
				} else {
					elem.hide();
				}
			})
		}

		// When .sw button are clicked, switch the screen
		menu.find('.sw').on('click', function () {
			var scrn = $(this).data('screen');
			switch_screen(scrn);
		})

		menu.find('.refresh').on('click', function () {
			window.menu.emit('do', {action:'get_servers'});
		})

		// When .action buttons are clicked, invoke the client
		menu.find('.submit').on('click', function () {
			var formName = $(this).data('form');

			// Serialize the form
			data = menu_form_to_data(formName);

			// Invoke the game client's menu interface
			window.menu.emit('do', data);
		})

		

		window.menu.on('serverlist', function (games) {

			serverListElem = menu.find('.servers').first()
				.find('.tbody').first();

			serverListElem.html('');

			for (var i=0; i < games.length; i++) {
				game = games[i];

				var serverElem = $(document.createElement('div'));
				serverElem.addClass('server');
				serverElem.addClass('button');
				serverElem.attr('tabindex', '0');

				var elemInput = $(document.createElement('input'));
				elemInput.attr('type','hidden');
				elemInput.attr('name','index');
				elemInput.attr('value', game.index);

				serverElem.append(elemInput);

				var fields = ['name', 'map', 'pop'];

				for (fld in fields) { field = fields[fld]
					var elemField = $(document.createElement('div'));
					elemField.addClass('field');
					elemField.addClass(field);
					console.log(field)
					if (typeof game[field] === 'undefined')
						elemField.html('undefined')
					else elemField.html(game[field]);

					serverElem.append(elemField);
				}

				serverListElem.append(serverElem);
			}

			bind_server_buttons();
		})

		window.menu.on('connected', function () {
			console.log("Connected!")
			window.menu.emit('do', {action:'get_servers'});
		})

		window.menu.on('gameon', function () {
			menu.hide();
		});

		window.menu.emit('ready');
	};

	bind_menu();

});
