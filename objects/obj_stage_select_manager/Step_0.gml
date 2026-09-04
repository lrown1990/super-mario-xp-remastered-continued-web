if(global.start || global.jump) {
	global.hearts = load_property("hearts");
	global.playerWeapon = load_property("weapon");
	global.pHealth = real(string_digits(load_property("health")));
	// Lives are in the save now, written at the start of every level. When they
	// are not there (empty save, or a run that ended with none left) the count
	// falls back to the five a new game starts with.
	var vite = load_property("lives");
	if(!is_real(vite) || vite <= 0) vite = 5;
	global.playerLives = vite;
	global.playerDead = false;
	room_goto(stage_intro);
}

global.currentStage = stageValues[currentSelection];

if(!pressed && global.horizontal != 0) {
	pressed = true;
	audio_play_sound(snd_cursor_move, 1, false);
	if(currentSelection == array_length(stageValues) - 1 && global.horizontal == 1) {
		audio_stop_sound(snd_cursor_move);
	} else if(currentSelection == 0 && global.horizontal == -1) {
		audio_stop_sound(snd_cursor_move);
	}
	currentSelection = clamp(currentSelection + global.horizontal, 0, array_length(stageValues) - 1);
}

if(pressed && global.horizontal == 0) {
	pressed = false;
}