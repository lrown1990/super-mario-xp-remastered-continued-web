// Il tentacolo che spunta da terra (Boss_02 nell'originale).
// Non si muove a caso: segue il percorso registrato nell'editor del 2001,
// quattro tratti, letti dal file. Le durate vengono da "pixel al secondo".

depth = 29;

// Quanto sale la stoccata. Sul video dell'originale la cima si ferma a
// y=138 con il camminamento a y=159, cioe' 21 pixel sopra; con 75 qui si
// ottiene proprio quello. Ma nella nostra arena il piano di calpestio non
// sta alla stessa quota del video, e dal vivo il tentacolo risultava appena
// sopra il ponte: portato a 95, cioe' una ventina di pixel piu' su.
salita = 95;

// MISURATO SUL VIDEO. La formula della documentazione da' 375 pixel al
// secondo; l'originale ne fa 216, misurati sulla stoccata intera (90 pixel
// dalla quota 228 alla 138, in 10 fotogrammi a 23,976 al secondo). Il
// rapporto e' 1,74, non 2: la prima misura che avevo fatto copriva solo un
// pezzo della salita e dava "esattamente meta'", ma era incompleta.
rallenta = 1.74;

// tratto: [attesa PRIMA, pixel in Y, secondi di percorrenza]
// L'originale ha un solo tratto di salita (75 px) con una pausa di 2 secondi.
// Dov'e' quella pausa, prima o dopo, il file non lo dice. La memoria di chi ci
// ha giocato dice che il tentacolo si vede spuntare dal basso per uno o due
// secondi e POI scatta verso l'alto, quindi la pausa e' prima della stoccata:
// una prima uscita breve, l'attesa, poi il resto della salita.
// Misurato sul video: il tentacolo NON esce gradualmente. Compare gia' alla
// sua quota d'attesa, con la cima a y=230 (dieci pixel sopra il fondo della
// stanza), ci resta mezzo secondo mordendo, e POI fa un'unica stoccata di
// una novantina di pixel fino a portare la cima a y=138. La pianta lo crea
// gia' in quella posizione, non piu' in basso.
// L'attesa in cima era 2,0 secondi, il valore del percorso originale.
// Portata a 1,5 su richiesta dell'utente: mezzo secondo in meno fermo a
// mordere prima di riscendere. La vita di un tentacolo passa da 4,9 a 4,4
// secondi, e il tempo in cui la testa sta sopra il piano del ponte (y=160)
// da 2,9 a 2,4 secondi.
legs = [
	[0.5, -salita, rallenta * salita / 375],
	[0.0,      -8, rallenta *   8 / 125],
	[0.0,      -6, rallenta *   6 /  62],
	[1.5,     121, rallenta * 121 / 125]
];

segment = 0;
segmentTime = 0;
pauseTime = 0;
startY = y;
dying = false;
paused = false;
