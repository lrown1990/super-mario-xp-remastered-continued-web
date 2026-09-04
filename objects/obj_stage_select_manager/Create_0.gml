audio_stop_all();
audio_play_sound(bgm_stageselect_remaster, 1, true);

currentSelection = 0;
stageValues = [];

for(var i = 1; i <= load_property("currentStage"); i++) {
	stageValues[i-1] = i;
}

// With no finished stage the loop above leaves the list empty, and the Step
// event then reads stageValues[-1], which kills the game to a black screen.
// Stage 1 is always reachable, so it is the sensible floor.
if(array_length(stageValues) == 0) {
	stageValues[0] = 1;
}

currentSelection = array_length(stageValues) - 1;

pressed = false;