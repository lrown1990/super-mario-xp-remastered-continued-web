// Kamek, the stage 6 boss (original level 57, "6-5", event group "kamekku").
// Every number below is read out of the 2001 original's events and carries the
// number of the event it comes from; the full reading is in
// port/marioxp-originale/BOSS-KAMEK-SPECIFICA.md. The ones that had to be
// converted into this port's units are marked "to be tuned".

depth = 30;

// The original counts an alterable value from 0 down to -30 (ev. 280). Here it
// counts down from 30, so the thresholds become the numbers below.
// Damage: stomp -2 (ev. 276), fireball -1 (277), hammer -1 (278), cross -2
// (279). Nothing else touches him: the headbutt from below does NOT hurt him,
// and there is no instant kill.
vita = 30;
VITA_BLOCCHI = 20;         // ev. 289 (-10): from here on he summons blocks
VITA_DUE_PALLE = 15;       // ev. 287 (-15): from here on the spell throws two
VITA_BLOCCHI_FITTI = 10;   // ev. 292 (-20): from here on the blocks rain faster

// He never changes height: no event in the whole group touches his Y. All he
// does is slide sideways towards an invisible anchor, 8 pixels a step with no
// "Every" (ev. 270 and 271), which at the original's 50 frames a second is
// 400 px/s. MEASURED on the longplay, entrance dash at 36:45: he goes from
// x=264 to x=28 in 0.6 s, which is 393 px/s. So the calculated figure was
// right and halving it, as the tentacle of boss 2 needed, was wrong here.
VELOCITA_SCATTO = 400;
ARRIVATO = 3;              // how close counts as "on the anchor"

// ev. 282 and 276-279: the anchor jumps to 10 + Random 300.
ANCORA_MIN = 10;
ANCORA_MAX = 309;

// The four dice: each has its own period and its own one-in-four draw
// (ev. 282, 284/285, 289, 295), and all four need him standing on his anchor.
ATTESA_SPOSTA = 0.5;
ATTESA_MAGIA = 0.3;
ATTESA_EVOCA = 1.0;
ATTESA_THWOMP = 1.0;
PROBABILITA = 4;

// ev. 272: while he is NOT on his anchor he drops an after-image every 50 ms.
// The trail the original leaves is SHORT: on the video it reaches about one
// body behind him, some 40 pixels, which at 400 px/s is a tenth of a second.
// That is why each after-image has to die quickly: the length of the trail is
// set by the frame rate of spr_boss_6_trail (7 frames at 60 fps), not here.
PASSO_SCIA = 0.05;

// ev. 286/287: the bolt leaves at the END of the spell animation, at the
// original's speed 30, and a second one at 40 once he is angry. MEASURED on
// the video, the pair at 37:03: the trailing one covers 78 pixels in 0.46 s
// and the leading one 104, so 170 and 226 px/s. Their ratio is 1.33, which is
// exactly 40/30: the two shots really do have the original's two speeds, and
// they leave from the same point and draw apart as they fly.
VELOCITA_PALLA = 170;
VELOCITA_PALLA_2 = 226;

// ev. 291/292: while the summoning animation runs, a block every 150 ms, every
// 100 ms once he is angry, dropped wherever the invisible Damy_04 happens to
// be. That dummy moves every 100 ms to x = 10 + Random 300, y = 32 + Random 64
// (ev. 269), so the blocks rain from random points of the upper band.
PASSO_BLOCCHI = 0.15;
PASSO_BLOCCHI_FITTI = 0.1;
BLOCCO_X_MIN = 10;
BLOCCO_X_MAX = 309;
BLOCCO_Y_MIN = 32;
BLOCCO_Y_MAX = 96;
// How long the summoning lasts. The original just plays animation 13 and lets
// it end, and a Clickteam animation speed does not convert into seconds, so it
// is sized on what the video shows: counting the stones on screen through the
// summon at 37:10 there are SIX of them at the peak. At one every 150 ms that
// is 0.9 s. Angry he throws one every 100 ms over the same time, so nine.
DURATA_EVOCA = 0.9;

// The death, timed on the longplay: he is squashed flat in 0.88 s, then LIES
// THERE INTACT for 1.15 s, and only after that does the flat shape dissolve,
// in 0.64 s. In the original they are two animations of the same object
// (Kouka_06, the 0 and the 4), which is why the pause between them exists at
// all: the Stopped animation ends and holds until the Disappearing one starts.
DURATA_SCHIACCIATA = 0.87;   // 13 frames at 15 a second
PAUSA_MORTE = 1.15;

GRAZIA_DANNO = 0.4;        // short window after a hit, as for the dinosaurs
LAMPEGGIO = 0.4;           // how long animation 15 shows

stato = "scatto";          // scatto | fermo | magia | evoca | thwomp | morto
ancoraX = 24;              // Boss_01 starts at (24,208): he crosses the room
direzione = -1;
attesaSposta = 0;
attesaMagia = 0;
attesaEvoca = 0;
attesaThwomp = 0;
attesaScia = 0;
attesaBlocco = 0;
tempoEvoca = 0;
graziaDanno = 0;
lampeggio = 0;
morteTimeout = 0;
musicaMorte = false;
ripulito = false;   // la pulizia di fine combattimento si fa una volta sola

sprite_index = spr_boss_6;
image_speed = 1;
image_index = 0;
image_xscale = direzione;
