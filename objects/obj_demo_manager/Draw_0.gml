// Opening screen, all text: the names used to be two images
// (obj_matth33w_logo and obj_cnc_logo, coloured lettering with a glow).
// They have been taken out of the room; the objects and the sprites stay in
// the project in case anyone ever wants to go back.
//
// Each block is a white caption with the name below it in its own colour:
// red and green as the two logos were, yellow for the third, which is also
// the colour of the selected entry in the game's menus.
// Green: c_lime and not c_green, because in GameMaker c_green is a DARK
// green (0x008000) that is barely readable on black; c_lime is the bright
// green of the old logo's glow.
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(small_font);

// In the order it happened: first whoever wrote it in 2001, then whoever
// rebuilt it in GameMaker, then whoever picked it up again.
var crediti = [
	["Original by:",             "CnC Darkside",  c_lime],
	["Remaster by:",             "Matth33w",      c_red],
	["Forked and continued by:", "Carlo Sinatra", c_yellow]
];

// Three blocks of two lines, spread over the 240 pixels of the screen: the
// first starts at 40, one every 64 after that, and the name sits 21 below
// its caption. The last line ends at 206, so the space above and below is
// nearly the same.
var yPrimo = 40, passoBlocco = 64, passoRiga = 21;

for(var i = 0; i < array_length(crediti); i++) {
	var yBlocco = yPrimo + i * passoBlocco;

	draw_set_color(c_white);
	draw_text(room_width / 2, yBlocco, crediti[i][0]);

	draw_set_color(crediti[i][2]);
	draw_text(room_width / 2, yBlocco + passoRiga, crediti[i][1]);
}

draw_set_color(c_white);
