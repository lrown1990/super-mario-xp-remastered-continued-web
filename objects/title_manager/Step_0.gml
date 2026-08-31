// RIQUADRO DI CONFERMA DI "NEW GAME".
// Sta in cima perche' finche' e' aperto il menu dietro deve restare fermo:
// il passo si chiude qui con un return. L'unica uscita in avanti e' il YES,
// che accende la variabile locale qui sotto e prosegue nella selezione di
// sempre, con i suoi suoni e la sua attesa di due secondi.
var confermaNuovaPartita = false;

if(confirming) {
	if(global.horizontal != 0 && !confirmMoved) {
		confirmMoved = true;

		// sinistra e' YES, destra e' NO, come sono disegnati
		var scelta = (global.horizontal < 0);

		if(scelta != confirmYes) {
			confirmYes = scelta;
			audio_play_sound(snd_cursor_move, 1, false);
		}
	} else if(global.horizontal == 0) {
		confirmMoved = false;
	}

	// X chiude il riquadro senza fare niente, come il NO
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
	// il YES del riquadro vale per "New game" e basta: se in quel momento era
	// premuta anche una freccia, il cursore dietro non deve dirottare la
	// scelta su un'altra voce
	if(confermaNuovaPartita)
		currentOption = 1;

	if(currentOption == 2 && stageCount < 2) {
		return;
	}

	// "New game" con una partita salvata: prima si chiede conferma, e la
	// selezione vera arriva solo dopo il YES. Senza salvataggio non c'e'
	// niente da perdere e si tira dritto come prima.
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
			// NUOVA PARTITA: si riparte davvero da zero. Prima non si azzerava
			// niente, e siccome obj_game_manager e' persistente (il suo Create
			// gira una volta sola all'avvio), dopo aver giocato "new game"
			// ripartiva dallo stadio gia' raggiunto, con i cuori e l'arma di
			// prima. Qui si rimettono i valori iniziali e si cancella la
			// partita salvata, cosi' anche "Select Stage" torna bloccato.
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