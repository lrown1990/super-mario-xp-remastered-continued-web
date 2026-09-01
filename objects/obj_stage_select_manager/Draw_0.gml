draw_set_halign(fa_center);
draw_set_valign(fa_center);
draw_set_color(c_white);
draw_set_font(small_font);

// Matth33w used to print "SMXP:R - SAGE 2022 DEMO" up here, the label of
// the demo build he had prepared for the Sonic Amateur Games Expo. Removed:
// on this fork it announced a 2022 demo of an event that has nothing to do
// with us, and empty space at the top of the map looks better than a line
// that means nothing to the player. The drawing settings above are still
// needed by the rest of the screen, they stay.

// The chosen character shows up on the map, on the destination of the stage
// you are highlighting. The point is not written by hand: it reads the LAST
// POINT of the path the game uses for the walk in stage_intro, so the
// marker is bound to sit where the character will stop after confirming,
// even if a path is ever adjusted.
var percorso = -1;
switch(global.currentStage) {
	case 1: { percorso = path_mario_world_map_1; break; }
	case 2: { percorso = path_mario_world_map_2; break; }
	case 3: { percorso = path_mario_world_map_3; break; }
	case 4: { percorso = path_mario_world_map_4; break; }
	case 5: { percorso = path_mario_world_map_5; break; }
	case 6: { percorso = path_mario_world_map_6; break; }
	case 7: { percorso = path_mario_world_map_7; break; }
}

if(percorso != -1) {
	var arrivo = path_get_number(percorso) - 1;
	draw_sprite(global.character == "luigi" ? spr_luigi_world_map_idle : spr_mario_world_map_idle,
	            0, path_get_point_x(percorso, arrivo), path_get_point_y(percorso, arrivo));
}

switch(global.currentStage) {
	case 1: {
		switch(global.language) {
			case "eng": {
				draw_text(room_width / 2, room_height - 16, "STAGE-1 Castle Courtyard");
				break;
			}
			
			case "ptbr": {
				draw_text(room_width / 2, room_height - 16, "STAGE-1 Entrada do Castelo");
				break;
			}
			
			case "jp": {
				draw_text(room_width / 2, room_height - 16, "STAGE-1 恶魔城入口");
				break;
			}
		}
		global.lastRoom = stage_1_1;
		global.initialWarping = false;
		break;
	}
	
	case 2: {
		switch(global.language) {
			case "eng": {
				draw_text(room_width / 2, room_height - 16, "STAGE-2 Observation Tower");
				break;
			}
			
			case "ptbr": {
				draw_text(room_width / 2, room_height - 16, "STAGE-2 Torre de Observação");
				break;
			}
			
			case "jp": {
				draw_text(room_width / 2, room_height - 16, "STAGE-2 監視塔");
				break;
			}
		}
		global.lastRoom = stage_2_1;
		global.initialWarping = false;
		break;
	}
	
	case 3: {
		switch(global.language) {
			case "eng": {
				draw_text(room_width / 2, room_height - 16, "STAGE-3 Underground Entrance");
				break;
			}
			
			case "ptbr": {
				draw_text(room_width / 2, room_height - 16, "STAGE-3 Entrada ao Subterrâneo");
				break;
			}
			
			case "jp": {
				draw_text(room_width / 2, room_height - 16, "STAGE-3 空中庭園~礼拜堂");
				break;
			}
		}
		global.lastRoom = stage_3_1;
		global.initialWarping = false;
		break;
	}
	
	case 4: {
		switch(global.language) {
			case "eng": {
				draw_text(room_width / 2, room_height - 16, "STAGE-4 Underground Water Veins");
				break;
			}
			
			case "ptbr": {
				draw_text(room_width / 2, room_height - 16, "STAGE-4 Fontes Subterrâneas");
				break;
			}
			
			case "jp": {
				draw_text(room_width / 2, room_height - 16, "STAGE-4 地下水脈");
				break;
			}
		}
		global.lastRoom = stage_4_1;
		global.initialWarping = false;
		break;
	}
	
	case 5: {
		switch(global.language) {
			case "eng": {
				draw_text(room_width / 2, room_height - 16, "STAGE-5 Castle Main Building");
				break;
			}
			
			case "ptbr": {
				draw_text(room_width / 2, room_height - 16, "STAGE-5 Construção Principal");
				break;
			}
			
			case "jp": {
				draw_text(room_width / 2, room_height - 16, "STAGE-5 悪魔城本館");
				break;
			}
		}
		global.lastRoom = stage_5_1;
		global.initialWarping = false;
		break;
	}
	
	case 6: {
		switch(global.language) {
			case "eng": {
				draw_text(room_width / 2, room_height - 16, "STAGE-6 Clock Tower");
				break;
			}
			
			case "ptbr": {
				draw_text(room_width / 2, room_height - 16, "STAGE-6 Torre do Relógio");
				break;
			}
			
			case "jp": {
				draw_text(room_width / 2, room_height - 16, "STAGE-6 時計塔");
				break;
			}
		}
		global.lastRoom = stage_6_1;
		global.startX = 80;
		global.startY = 208;

		global.initialWarping = true;
		global.initialWarpDirection = "up";
		break;
	}
	
	case 7: {
		switch(global.language) {
			case "eng": {
				draw_text(room_width / 2, room_height - 16, "STAGE-7 Top of the Castle");
				break;
			}
			
			case "ptbr": {
				draw_text(room_width / 2, room_height - 16, "STAGE-7 Topo do Castelo");
				break;
			}
			
			case "jp": {
				draw_text(room_width / 2, room_height - 16, "STAGE-7 悪魔城最上部");
				break;
			}
		}
		global.lastRoom = stage_7_1;
		global.initialWarping = false;
		break;
	}
}