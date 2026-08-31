switch(global.language) {
	case "eng": {
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		draw_text(room_width / 2, 8 * 2, "OPTIONS");
		draw_set_halign(fa_left);
		draw_set_color(arrCurrent == 0 ? c_yellow : c_white);
		draw_text(16, 8 * 4, "Character:");
		switch(global.character) {
			case "mario": {
				draw_text(16, 8 * 6, "MARIO");
				draw_set_color(c_ltgray);
				draw_text(16, 8 * 8, "BALANCED");
				break;
			}
			
			case "luigi": {
				draw_text(16, 8 * 6, "LUIGI");
				draw_set_color(c_ltgray);
				draw_text(16, 8 * 8, "FASTER, JUMPS HIGHER, WEAKER");
				break;
			}
		}
		draw_set_color(arrCurrent == 1 ? c_yellow : c_white);
		draw_text(16, 8 * 11, "Parallax:");
		switch(global.parallaxScrolling) {
			case true: {
				draw_text(16, 8 * 13, "ACTIVATED");
				break;
			}
			
			case false: {
				draw_text(16, 8 * 13, "DEACTIVATED");
				break;
			}
		};
		draw_set_color(arrCurrent == 2 ? c_yellow : c_white);
		draw_text(16, 8 * 16, "Smooth transitions:");
		switch(global.smoothTransitions) {
			case true: {
				draw_text(16, 8 * 18, "ACTIVATED");
				break;
			}
			
			case false: {
				draw_text(16, 8 * 18, "DEACTIVATED");
				break;
			}
		};
		draw_set_color(arrCurrent == 3 ? c_yellow : c_white);
		draw_text(16, room_height - 8 * 2, "Exit");
		break;
	}
	
	case "ptbr": {
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		draw_text(room_width / 2, 8 * 2, "AJUSTES");
		draw_set_halign(fa_left);
		draw_set_color(arrCurrent == 0 ? c_yellow : c_white);
		draw_text(16, 8 * 4, "Personagem:");
		switch(global.character) {
			case "mario": {
				draw_text(16, 8 * 6, "MARIO");
				draw_set_color(c_ltgray);
				draw_text(16, 8 * 8, "BALANCED");
				break;
			}
			
			case "luigi": {
				draw_text(16, 8 * 6, "LUIGI");
				draw_set_color(c_ltgray);
				draw_text(16, 8 * 8, "FASTER, JUMPS HIGHER, WEAKER");
				break;
			}
		}
		draw_set_color(arrCurrent == 1 ? c_yellow : c_white);
		draw_text(16, 8 * 11, "Parallax:");
		switch(global.parallaxScrolling) {
			case true: {
				draw_text(16, 8 * 13, "ATIVADO");
				break;
			}
			
			case false: {
				draw_text(16, 8 * 13, "DESATIVADO");
				break;
			}
		};
		draw_set_color(arrCurrent == 2 ? c_yellow : c_white);
		draw_text(16, 8 * 16, "Transições suaves:");
		switch(global.smoothTransitions) {
			case true: {
				draw_text(16, 8 * 18, "ATIVADO");
				break;
			}
			
			case false: {
				draw_text(16, 8 * 18, "DESATIVADO");
				break;
			}
		};
		draw_set_color(arrCurrent == 3 ? c_yellow : c_white);
		draw_text(16, room_height - 8 * 2, "Sair");
		break;
	}
	
	case "jp": {
		draw_set_halign(fa_center);
		draw_set_color(c_white);
		draw_text(room_width / 2, 8 * 2, "OPTIONS");
		draw_set_halign(fa_left);
		draw_set_color(arrCurrent == 0 ? c_yellow : c_white);
		draw_text(16, 8 * 4, "Character:");
		switch(global.character) {
			case "mario": {
				draw_text(16, 8 * 6, "MARIO");
				draw_set_color(c_ltgray);
				draw_text(16, 8 * 8, "BALANCED");
				break;
			}
			
			case "luigi": {
				draw_text(16, 8 * 6, "LUIGI");
				draw_set_color(c_ltgray);
				draw_text(16, 8 * 8, "FASTER, JUMPS HIGHER, WEAKER");
				break;
			}
		}
		draw_set_color(arrCurrent == 1 ? c_yellow : c_white);
		draw_text(16, 8 * 11, "Parallax:");
		switch(global.parallaxScrolling) {
			case true: {
				draw_text(16, 8 * 13, "ACTIVATED");
				break;
			}
			
			case false: {
				draw_text(16, 8 * 13, "DEACTIVATED");
				break;
			}
		};
		draw_set_color(arrCurrent == 2 ? c_yellow : c_white);
		draw_text(16, 8 * 16, "Smooth transitions:");
		switch(global.smoothTransitions) {
			case true: {
				draw_text(16, 8 * 18, "ACTIVATED");
				break;
			}
			
			case false: {
				draw_text(16, 8 * 18, "DEACTIVATED");
				break;
			}
		};
		draw_set_color(arrCurrent == 3 ? c_yellow : c_white);
		draw_text(16, room_height - 8 * 2, "Exit");
		break;
	}
}