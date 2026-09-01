// Paths 4-7 are recovered from the original: the starting position is taken
// from the level's own Stage Map_N screen, and the route was followed frame
// by frame in recorded footage. Speed 0.4: the original walks at 24 pixels
// per second and the game runs at 60 frames per second.
switch(global.currentStage) {
	case 1: {
		path_start(path_mario_world_map_1, 0.4, path_action_stop, true);
		break;
	}
	
	case 2: {
		path_start(path_mario_world_map_2, 0.5, path_action_stop, true);
		break;
	}
	
	case 3: {
		path_start(path_mario_world_map_3, 0.5, path_action_stop, true);
		break;
	}
	
	case 4: {
		path_start(path_mario_world_map_4, 0.4, path_action_stop, true);
		break;
	}
	
	case 5: {
		path_start(path_mario_world_map_5, 0.4, path_action_stop, true);
		break;
	}
	
	case 6: {
		path_start(path_mario_world_map_6, 0.4, path_action_stop, true);
		break;
	}
	
	case 7: {
		path_start(path_mario_world_map_7, 0.4, path_action_stop, true);
		break;
	}
}
