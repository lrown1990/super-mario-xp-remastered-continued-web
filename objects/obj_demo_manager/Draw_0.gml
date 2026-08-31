// Schermata d'apertura, tutta a testo: prima i nomi erano due immagini
// (obj_matth33w_logo e obj_cnc_logo, scritte colorate con l'alone). Sono state
// tolte dalla stanza, gli oggetti e gli sprite restano nel progetto se un
// domani si volesse tornare indietro.
//
// Ogni blocco e' una dicitura bianca e sotto il nome nel suo colore: rosso e
// verde come erano i due loghi, giallo per il terzo, che e' anche il colore
// della voce scelta nei menu del gioco.
// Verde: si usa c_lime e non c_green perche' in GameMaker c_green e' un verde
// SCURO (0x008000) e su fondo nero si legge appena; c_lime e' il verde acceso
// dell'alone del logo di prima.
draw_set_halign(fa_center);
draw_set_valign(fa_top);
draw_set_font(small_font);

// In ordine di come e' andata: prima chi l'ha scritto nel 2001, poi chi l'ha
// rifatto in GameMaker lasciandolo a meta', poi chi l'ha ripreso.
var crediti = [
	["Original by:",             "CnC Darkside",  c_lime],
	["Partial remaster by:",     "Matth33w",      c_red],
	["Forked and continued by:", "Carlo Sinatra", c_yellow]
];

// Tre blocchi da due righe, distribuiti sui 240 pixel dello schermo: il primo
// parte a 40, se ne va uno ogni 64, e il nome sta 21 sotto la sua dicitura.
// L'ultima riga finisce a 206, quindi lo spazio sopra e sotto e' quasi uguale.
var yPrimo = 40, passoBlocco = 64, passoRiga = 21;

for(var i = 0; i < array_length(crediti); i++) {
	var yBlocco = yPrimo + i * passoBlocco;

	draw_set_color(c_white);
	draw_text(room_width / 2, yBlocco, crediti[i][0]);

	draw_set_color(crediti[i][2]);
	draw_text(room_width / 2, yBlocco + passoRiga, crediti[i][1]);
}

draw_set_color(c_white);
