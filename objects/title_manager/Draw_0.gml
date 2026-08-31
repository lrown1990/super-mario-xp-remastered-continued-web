draw_set_halign(fa_center);
draw_set_valign(fa_center);

draw_set_color(c_white);

if(currentOption == 1) {
	draw_sprite_ext(spr_new_game, 0, (room_width / 2), 158, 1, 1, 0, c_yellow, 1);
} else {
	draw_sprite_ext(spr_new_game, 0, (room_width / 2), 158, 1, 1, 0, c_white, 1);
}

if(currentOption == 2) {
	if(stageCount > 1) {
		draw_sprite_ext(spr_stage_select, 0, (room_width / 2), 178, 1, 1, 0, c_yellow, 1);
	} else {
		draw_sprite_ext(spr_stage_select, 0, (room_width / 2), 178, 1, 1, 0, c_red, 1);
	}
} else {
	if(stageCount > 1) {
		draw_sprite_ext(spr_stage_select, 0, (room_width / 2), 178, 1, 1, 0, c_white, 1);
	} else {
		draw_sprite_ext(spr_stage_select, 0, (room_width / 2), 178, 1, 1, 0, c_gray, 1);
	}
}

if(currentOption == 3) {
	draw_sprite_ext(spr_options, 0, (room_width / 2), 198, 1, 1, 0, c_yellow, 1);
} else {
	draw_sprite_ext(spr_options, 0, (room_width / 2), 198, 1, 1, 0, c_white, 1);
}

// La firma "Web port done by Carlo Sinatra" stava qui in fondo, a y=228, ed e'
// stata tolta: il credito e' passato nella schermata d'apertura, dove non e'
// piu' descritto come un semplice port. Il menu resta alle quote di adesso
// (158/178/198), alzate di 12px a suo tempo per fare posto alla firma.
draw_set_font(small_font);

switch(currentOption) {
	case 1: {
		draw_sprite_ext(menu_cursor, image_index, (room_width / 2), 158, 1, 1, 0, c_white, 1);
		break;
	}
	
	case 2: {
		draw_sprite_ext(menu_cursor, image_index, (room_width / 2), 178, 1, 1, 0, c_white, 1);
		break;
	}
	
	case 3: {
		draw_sprite_ext(menu_cursor, image_index, (room_width / 2), 198, 1, 1, 0, c_white, 1);
		break;
	}
}
// ---- riquadro di conferma di "New game" --------------------------------
// Va disegnato per ultimo: copre il menu, che intanto e' fermo (vedi lo Step).
// Nel gioco non c'e' nessun altro riquadro da cui copiare lo stile, quindi e'
// quello dei giochi dell'epoca: fondo nero, cornice bianca, e la voce in
// evidenza in giallo come nella schermata delle opzioni. Il testo resta in
// inglese come tutto il resto delle scritte, anche nei blocchi "ptbr".
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
