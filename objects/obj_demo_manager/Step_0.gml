demoTimeout += delta_time / 1000000;

if(demoTimeout > 1) {
	layer_hspeed("Fade_In", 8);
}

// Si salta con INVIO o con Z, i due tasti di conferma del gioco. Sono gia'
// pronti in global.start e global.jump, che obj_game_manager aggiorna nel
// Begin Step, e sono tutti e due "appena premuto": la stessa pressione non
// riparte quindi sul menu del titolo, che gira dal fotogramma dopo.
// ESC NO, anche se sembrerebbe il tasto giusto: dentro CARLO_OS quello e' il
// tasto della pausa della finestra, lo intercetta il sito e metterebbe in
// pausa mentre qui si salta.
// Quattro secondi, non piu' tre: i crediti sono diventati tre blocchi.
if(demoTimeout > 4 || global.start || global.jump) {
	// Si va diritti al titolo: la scelta della lingua e' stata tolta perche'
	// scegliendo giapponese o portoghese la stragrande maggioranza dei testi
	// resta comunque in inglese, quindi era una domanda senza risposta utile.
	// L'inglese e' gia' la lingua predefinita (global.language in
	// obj_game_manager/Create_0.gml). La stanza language_select e i suoi
	// oggetti restano nel progetto, solo non ci passa piu' nessuno: per
	// rimetterla basta ripristinare questa riga.
	room_goto(title_screen);
}