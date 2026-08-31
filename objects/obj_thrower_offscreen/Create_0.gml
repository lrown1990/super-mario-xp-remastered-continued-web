// Il "killer" che entra da destra a mezz'aria in 3-1, come nell'originale del
// 2001: livello 25 ("3-1"), gruppo di eventi キラー, evento 312.
// Non e' un cannone piazzato nel quadro come obj_thrower: nell'originale e' un
// segnaposto agganciato allo SCHERMO (l'oggetto Damy_02), quindi il colpo
// arriva sempre da fuori inquadratura a destra, a un'altezza sorteggiata.
counter = 0;

// Il tratto in cui succede: Mario fra X 1200 e 3000 (ev. 312). Le coordinate
// dell'originale valgono tali e quali, perche' li' il quadro e' 3200x240 ed e'
// la misura esatta di questa stanza.
fromX = 1200;
toX = 3000;

// Un colpo ogni 3 secondi (ev. 312, "ogni 3000 ms"). E' anche la cadenza dei
// cannoni gia' nel gioco, obj_thrower.
period = 3;

// Le quote possibili, una ogni 16 pixel come nell'originale, dove la Y del
// segnaposto e' "bordo alto dello schermo + casuale(16) * 16 - 8" (ev. 14):
// sedici righe allineate alla griglia delle piastrelle.
// QUI PERO' SOLO LA FASCIA ALTA, per scelta dell'utente: le righe in fondo
// darebbero un colpo di cannone che si sente e non si vede, perche' passa
// sotto le piattaforme, e nell'originale non e' mai successo. La prima riga
// dell'originale (-8) sarebbe pure mezza fuori dallo schermo in cima.
// Restano dieci quote, da 8 a 152: tutte dentro l'inquadratura e tutte
// all'altezza dei camminamenti di questo tratto, che stanno fra 96 e 160.
// Per allargare o stringere la fascia si toccano solo queste due righe.
rowFirst = 8;
rows = 10;
