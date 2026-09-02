// The Serpent - the stage 4 boss (level 40, "4-7", event group サーペント).
// Every number below comes from the original's events unless it says
// otherwise. See port/marioxp-originale/BOSS-SERPENTE-SPECIFICA.md

depth = 30;

// 25 points in all: it dies at -25 (ev. 173). Stomp 3, fire 1, hammer 1,
// cross 2 (ev. 166-169).
damagePoints = 25;

// In the original the serpent moves with Clickteam's "bouncing ball", which
// carries its own gravity: the events only handle the special cases, so the
// speed 60 of ev. 179 is NOT comparable with the third boss's numbers. Here
// the leap is an arc built by hand. VELOCITA_SALTO is chosen so that from
// the water it just clears the height where the original turns and opens its
// jaws (y < 90, ev. 182): 490 pixels per second against a gravity of 700
// gives an apex about 170 pixels up, which is exactly that.
VELOCITA_SALTO = 470;   // how hard it comes out of the water
// Lowered from 620: now that it waits down at QUOTA_FONDO instead of just
// under the surface, it has 172 pixels to climb before the height where it
// opens its jaws. With 620 it barely made it and the whole leap looked
// hurried; with 520 the same launch speed carries it comfortably and the arc
// is slower to read.
GRAVITA = 520;
VELOCITA_ARCO = 150;    // how fast it leans across while falling
VELOCITA_RIMBALZO = 210;// the head alone, in the last phase

// The head on its own does not sit on top of Mario: it goes PAST him, turns
// round out there and comes back. This is how far past him it aims.
SCARTO_RIMBALZO = 150;

// Under this line it is hidden and waiting. It is where the water objects
// of the arena sit.
QUOTA_ACQUA = 224;

// It comes out every second (ev. 179-180, "every 1000 ms").
// The floor of the pool. Well below the room, so the camera cuts it off: the
// serpent has to be all but invisible down there. It has to be deep enough
// for the ∪ to be a real curve - at 268 the dive hit the bottom and the
// curve flattened out.
QUOTA_FONDO = 390;

// Under water it does not sink and stop: it is pushed back up, so the path
// down there is a ∪, the mirror of the ∩ it draws in the air. That is what
// pulls the WHOLE body under - before this the head parked on the bottom and
// the tail stayed sticking out of the water.
SPINTA_ACQUA = 330;
DISCESA_MINIMA = 300;   // how hard it always goes in, so the dive is a dive

// It holds still with its jaws burning before the fireballs actually leave:
// a second and a bit of warning, which is what makes the attack readable.
SECONDI_BOCCA = 1.2;

vx = 0;                // pixels per second
vy = 0;

// acqua | salto | morso | arco | rimbalzo
// (water | leap | bite | arc | the head alone bouncing)
stato = "acqua";
soloTesta = false;      // second phase: the body is left behind
statoTimer = 0;

verso = -1;            // -1 left, 1 right: which way the head is looking
colpito = false;
colpitoTimeout = 0;
sputato = false;        // the three fireballs of this bite already gone?
attesaBocca = 0;        // how long it has been holding its jaws open
xBocca = x;             // where it was when it stopped, so the shake has a middle
latoRimbalzo = 1;       // which side the lone head is heading for

// WHICH ATTACK COMES NEXT. Watching the footage again there are two, and the
// long one is by far the commoner:
//  - "tuffo": it surfaces FAR from the player and sails across in one long
//    arc towards him, the way the fish jump in the earlier levels. No bite.
//  - "sputo": it comes up close to him, stops at the top with its jaws open
//    and throws the three fireballs.
// One in three is a sputo: coming up under his feet every single time, which
// is what it did before, is neither what the original does nor fair.
// How many times a single leap is allowed to bounce off the walkway before
// the walkway lets it through and it falls back into the water. One or two,
// drawn at the start of each leap.
rimbalziPonte = 0;
rimbalziMax = 1;

prossimoAttacco = "tuffo";
puntoLancio = x;

// How high the long arc climbs, and how far from the player it starts.
QUOTA_ARCO = 132;      // how high the arch climbs: the lower it goes, the wider it reads
DISTANZA_LANCIO = 310;
image_speed = 0;

// The breadcrumb trail the body rides on. A point is dropped every
// PASSO_SCIA pixels, and link i sits PASSO_SCIA * 4 * i pixels back, which
// puts the links 16 pixels apart - the spacing the nine parts have in the
// original's own layout (Boss_1..Boss_9 sit at x 240, 224, ... 112).
PASSO_SCIA = 4;
scia = [];
ultimoPunto = [x, y];

// The eight links, from the one behind the head to the tail. The sprites
// get smaller down the chain, exactly as in the original: 787 for links
// 2-6, 788 for the seventh, 802 for the eighth, 789 for the tail.
segmenti = [];
for(var i = 1; i <= 8; i++) {
	var s = instance_create_layer(x, y, "Objects", obj_boss_4_segment);
	s.indice = i;
	if(i <= 5) {
		s.sprite_normale = spr_boss_4_body;
		s.sprite_colpito = spr_boss_4_body_damaged;
	} else if(i == 6) {
		s.sprite_normale = spr_boss_4_body_2;
		s.sprite_colpito = spr_boss_4_body_2_damaged;
	} else if(i == 7) {
		s.sprite_normale = spr_boss_4_body_3;
		s.sprite_colpito = spr_boss_4_body_3_damaged;
	} else {
		s.sprite_normale = spr_boss_4_tail;
		s.sprite_colpito = spr_boss_4_tail_damaged;
	}
	s.sprite_index = s.sprite_normale;
	array_push(segmenti, s);
}

active = true;
defeatedTimeout = 0;
defeatedMusic = false;
eraSottAcqua = true;

// One hit: takes the points off and makes all nine parts flash (ev. 166-169).
function ferisci(punti) {
	damagePoints -= punti;
	colpito = true;
	colpitoTimeout = 0;
	with(obj_boss_4_segment) {
		colpito = true;
		colpitoTimeout = 0;
	}

	// SECOND PHASE. In the original, below half health the event that makes
	// the body follow the head stops running (ev. 162 only fires while the
	// counter is >= -15), and in the footage from 44:30 that is exactly what
	// you see: the body is gone and the head alone skims along the walkway
	// going for the player. Here the links are taken off for good and the
	// head switches to its own bouncing.
	if(damagePoints <= 10 && !soloTesta) {
		soloTesta = true;
		stato = "rimbalzo";
		vy = -VELOCITA_SALTO * 0.6;
		with(obj_boss_4_segment) {
			instance_create_layer(x, y, "Objects", obj_piranha_plant_defeated);
			instance_destroy();
		}
		segmenti = [];
		audio_play_sound(snd_boss_2_tentacle_dead, 1, false);
	}
}
