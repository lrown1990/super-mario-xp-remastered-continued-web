draw_set_halign(fa_center);
draw_set_valign(fa_center);

draw_set_color(c_white);

if(currentOption == 1) {
	draw_sprite_ext(spr_new_game, 0, (room_width / 2), 178, 1, 1, 0, c_yellow, 1);
} else {
	draw_sprite_ext(spr_new_game, 0, (room_width / 2), 178, 1, 1, 0, c_white, 1);
}

if(currentOption == 2) {
	if(stageCount > 1) {
		draw_sprite_ext(spr_stage_select, 0, (room_width / 2), 198, 1, 1, 0, c_yellow, 1);
	} else {
		draw_sprite_ext(spr_stage_select, 0, (room_width / 2), 198, 1, 1, 0, c_red, 1);
	}
} else {
	if(stageCount > 1) {
		draw_sprite_ext(spr_stage_select, 0, (room_width / 2), 198, 1, 1, 0, c_white, 1);
	} else {
		draw_sprite_ext(spr_stage_select, 0, (room_width / 2), 198, 1, 1, 0, c_gray, 1);
	}
}

if(currentOption == 3) {
	draw_sprite_ext(spr_options, 0, (room_width / 2), 218, 1, 1, 0, c_yellow, 1);
} else {
	draw_sprite_ext(spr_options, 0, (room_width / 2), 218, 1, 1, 0, c_white, 1);
}

// The line "Web port done by Carlo Sinatra" used to be down here, at y=228,
// and has been removed: the credit moved to the opening screen, where it is
// no longer described as just a port. The menu stays at its current heights
// (158/178/198), raised by 12px back then to make room for that line.
draw_set_font(small_font);

switch(currentOption) {
	case 1: {
		draw_sprite_ext(menu_cursor, image_index, (room_width / 2), 178, 1, 1, 0, c_white, 1);
		break;
	}
	
	case 2: {
		draw_sprite_ext(menu_cursor, image_index, (room_width / 2), 198, 1, 1, 0, c_white, 1);
		break;
	}
	
	case 3: {
		draw_sprite_ext(menu_cursor, image_index, (room_width / 2), 218, 1, 1, 0, c_white, 1);
		break;
	}
}
// ---- confirmation box for "New game" -----------------------------------
// It has to be drawn last: it covers the menu, which is frozen meanwhile
// (see the Step). There is no other box in the game to copy the style from,
// so it is the style of the games of the day: black fill, white frame, and
// the highlighted entry in yellow as on the options screen. The text stays
// in English like all the other lettering, in the "ptbr" blocks too.
if(confirming) {
	var riga1 = "WARNING!";
	var riga2 = "All saved data will be lost.";
	var riga3 = "Proceed?";

	var cx = room_width / 2;
	var largh = max(string_width(riga1), string_width(riga2), string_width(riga3)) + 24;
	var bx1 = cx - largh / 2, bx2 = cx + largh / 2;
	var by1 = 134, by2 = 218;

	draw_set_font(small_font);
	draw_set_halign(fa_center);
	draw_set_valign(fa_middle);

	draw_set_color(c_black);
	draw_rectangle(bx1, by1, bx2, by2, false);
	draw_set_color(c_white);
	draw_rectangle(bx1, by1, bx2, by2, true);

	draw_text(cx, by1 + 18, riga1);
	draw_text(cx, by1 + 34, riga2);
	draw_text(cx, by1 + 50, riga3);

	draw_set_color(confirmYes ? c_yellow : c_white);
	draw_text(cx - 40, by1 + 70, "YES");

	draw_set_color(confirmYes ? c_white : c_yellow);
	draw_text(cx + 40, by1 + 70, "NO");

	draw_set_color(c_white);
}
