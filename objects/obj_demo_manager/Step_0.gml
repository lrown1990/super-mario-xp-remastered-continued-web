demoTimeout += delta_time / 1000000;

if(demoTimeout > 1) {
	layer_hspeed("Fade_In", 8);
}

// You skip it with ENTER or Z, the game's two confirm keys. They are
// already prepared in global.start and global.jump, which obj_game_manager
// refreshes in the Begin Step, and both are "just pressed": the same
// keypress does not carry over into the title menu, which starts running on
// the next frame.
// NOT ESC, even though it looks like the right key: inside CARLO_OS that is
// the window's pause key, the site intercepts it and it would pause the
// game while you are trying to skip.
// Four seconds, not three any more: the credits have become three blocks.
if(demoTimeout > 4 || global.start || global.jump) {
	// Straight to the title: the language choice has been removed, because
	// picking Japanese or Portuguese leaves the vast majority of the text
	// in English anyway, so it was a question with no useful answer.
	// English is already the default (global.language in
	// obj_game_manager/Create_0.gml). The language_select room and its
	// objects stay in the project, nobody just goes there any more: to
	// bring it back, restore this line.
	room_goto(title_screen);
}