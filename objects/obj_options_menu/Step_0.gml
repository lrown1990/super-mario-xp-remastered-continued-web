if(!pressed && global.vertical != 0) {
	pressed = true;
	audio_play_sound(snd_cursor_move, 1, false);
	if(arrCurrent == array_length(arrProps) - 1 && global.vertical == 1) {
		audio_stop_sound(snd_cursor_move);
	} else if(arrCurrent == 0 && global.vertical == -1) {
		audio_stop_sound(snd_cursor_move);
	}
	arrCurrent = clamp(arrCurrent + global.vertical, 0, array_length(arrProps) - 1);
}

if(!pressedOption && global.horizontal != 0) {
	pressedOption = true;
	audio_play_sound(snd_cursor_move, 1, false);
	cambiato = true;
	switch(arrCurrent) {
		case 0: {
			if(arrCharacterCurrent == array_length(characterList) - 1 && global.horizontal == 1) {
				audio_stop_sound(snd_cursor_move);
			} else if(arrCharacterCurrent == 0 && global.horizontal == -1) {
				audio_stop_sound(snd_cursor_move);
			}
			arrCharacterCurrent = clamp(arrCharacterCurrent + global.horizontal, 0, array_length(characterList) - 1);
			break;
		}
		
		
		case 1: {
			if(arrParallaxCurrent == array_length(parallaxActivated) - 1 && global.horizontal == 1) {
				audio_stop_sound(snd_cursor_move);
			} else if(arrParallaxCurrent == 0 && global.horizontal == -1) {
				audio_stop_sound(snd_cursor_move);
			}
			arrParallaxCurrent = clamp(arrParallaxCurrent + global.horizontal, 0, array_length(parallaxActivated) - 1);
			break;
		}
		
		case 2: {
			if(arrTransitionCurrent == array_length(smoothTransitionsActivated) - 1 && global.horizontal == 1) {
				audio_stop_sound(snd_cursor_move);
			} else if(arrTransitionCurrent == 0 && global.horizontal == -1) {
				audio_stop_sound(snd_cursor_move);
			}
			arrTransitionCurrent = clamp(arrTransitionCurrent + global.horizontal, 0, array_length(smoothTransitionsActivated) - 1);
			break;
		}
	}
}

switch(arrCurrent) {
	case 0: {
		global.character = characterList[arrCharacterCurrent];
		break;
	}
	
	case 1: {
		global.parallaxScrolling = parallaxActivated[arrParallaxCurrent];
		break;
	}
	
	case 2: {
		global.smoothTransitions = smoothTransitionsActivated[arrTransitionCurrent];
		break;
	}
}

// Si scrive su disco appena una voce cambia, non all'uscita: il gioco vive in
// una finestra del browser e la si puo' chiudere in qualsiasi momento.
// Il blocco sta QUI, dopo lo switch che aggiorna le variabili globali dalla
// voce evidenziata: messo prima si salverebbe il valore vecchio.
if(cambiato) {
	cambiato = false;

	ini_open("save_data.xp");
	ini_write_string("options", "character", global.character);
	ini_write_real("options", "parallax", global.parallaxScrolling);
	ini_write_real("options", "transitions", global.smoothTransitions);
	ini_close();
}

if(pressed && global.vertical == 0) {
	pressed = false;
}

if(pressedOption && global.horizontal == 0) {
	pressedOption = false;
}

if(global.start)
	room_goto(title_screen);