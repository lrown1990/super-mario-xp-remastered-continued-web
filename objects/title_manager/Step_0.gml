// CONFIRMATION BOX FOR "NEW GAME".
// It sits at the top because while it is open the menu behind it has to
// stay frozen: the step ends here with a return. The only way forward is
// YES, which sets the local variable below and carries on into the usual
// selection, with its sounds and its two second wait.
var confermaNuovaPartita = false;

if(confirming) {
	if(global.horizontal != 0 && !confirmMoved) {
		confirmMoved = true;

		// left is YES, right is NO, the way they are drawn
		var scelta = (global.horizontal < 0);

		if(scelta != confirmYes) {
			confirmYes = scelta;
			audio_play_sound(snd_cursor_move, 1, false);
		}
	} else if(global.horizontal == 0) {
		confirmMoved = false;
	}

	// X closes the box without doing anything, same as NO
	if(global.attack) {
		confirming = false;
		audio_play_sound(snd_cursor_move, 1, false);
		return;
	}

	if(!(global.start || global.jump))
		return;

	confirming = false;

	if(!confirmYes) {
		audio_play_sound(snd_cursor_move, 1, false);
		return;
	}

	confermaNuovaPartita = true;
}

if(global.vertical != 0 && !cursorMoved && !selected) {
	currentOption += global.vertical;
	cursorMoved = true;
	audio_play_sound(snd_cursor_move, 1, false);
} else if (global.vertical == 0) {
	cursorMoved = false;
}

if(currentOption < 1)
	currentOption = 3;
else if(currentOption > 3)
	currentOption = 1;

if((global.start || global.jump || confermaNuovaPartita) && !selected) {
	// the box's YES applies to "New game" and nothing else: if an arrow key
	// happened to be held down at that moment, the cursor behind must not
	// divert the choice to another entry
	if(confermaNuovaPartita)
		currentOption = 1;

	if(currentOption == 2 && stageCount < 2) {
		return;
	}

	// "New game" with a saved game: it asks for confirmation first, and the
	// real selection only happens after YES. With no save there is nothing
	// to lose and it goes straight through as before.
	if(currentOption == 1 && hasSave && !confermaNuovaPartita) {
		confirming = true;
		confirmYes = false;
		confirmMoved = true;
		audio_play_sound(snd_impact_generic, 1, false);
		return;
	}

	selected = true;
	switch(global.character) {
		case "mario": {
			audio_play_sound(snd_mario_item_crash_1, 1, false);
			break;
		}
		
		case "luigi": {
			audio_play_sound(snd_luigi_item_crash_1, 1, false);
			break;
		}
	}
	audio_play_sound(snd_impact_generic, 1, false);
	image_speed = 2;
}

if(selected)
	timeout += delta_time / 1000000;
	
if(timeout > 2) {
	switch(currentOption) {
		case 1: {
			// NEW GAME: it really does start from scratch. Nothing used to
			// be reset, and since obj_game_manager is persistent (its
			// Create runs only once at startup), after playing, "new game"
			// restarted from the stage already reached, with the hearts and
			// the weapon from before. Here the initial values are put back
			// and the saved game is wiped, so that "Select Stage" goes back
			// to being locked as well.
			global.currentStage = 1;
			global.playerLives = 5;
			global.hearts = 10;
			global.pHealth = 5;
			global.playerWeapon = "none";
			global.playerDead = false;
			global.startX = -1;
			global.startY = -1;
			global.initialWarping = false;
			global.initialWarpDirection = "none";
			global.screenToWarp = noone;
			global.warpsEntered = [];
			global.lastRoom = stage_1_1;

			ini_open("save_data.xp");
			ini_write_string("save-data", "content", "");
			ini_close();

			room_goto(opening);
			break;
		}
		
		case 2: {
			room_goto(stage_select);
			break;
		}
		
		case 3: {
			room_goto(options_screen);
			break;
		}
	}
}