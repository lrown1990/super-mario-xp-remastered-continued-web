// The little dinosaurs, the stage 5 boss (level 50, "5-8", event group
// "buibui"). There are FOUR of them and each one is its own enemy with its own
// health: the original spawns Boss_01 at (72,304), (168,240), (272,48) and
// (552,-16). Every number below is read out of the original's events, see
// port/marioxp-originale/BOSS-DINO-SPECIFICA.md; the ones that had to be
// converted into this port's units are marked "to be tuned".

depth = 30;

// It dies when its counter reaches -6 (ev. 271). Fire and hammer take 2 off,
// weapon 3 takes 3, and the cross kills outright (ev. 272-278). There is NO
// stomp event at all: it cannot be killed from above.
vita = 6;

// At rest the original nudges it 2 pixels a step (ev. 283/284), and only at
// rest: see the Step. Halved here like the other enemies of this port.
PASSO = 1;
direzione = choose(-1, 1);      // ev. 262 flips the flag at frame start

// How far a hop carries it sideways. One lift column is 96 pixels apart, and
// the user describes it moving about one column, so this is sized to cover
// that in the time the hop lasts. To be tuned.
VELOCITA_SALTO = 1.6;
VICINO = 72;                    // closer than this it prefers to back off

// The six lift columns. A platform is 48 wide and its instance sits at the
// left edge, so the centre of a column is the platform x plus 24: 72, 168,
// 264, 360, 456, 552. Those are the same numbers the original uses to place
// the boss, and they sit inside its walls of 70 and 572 (ev. 267/268), which
// is the cross check that the boss really does stand on the column centres.
COLONNA_PRIMA = 72;
COLONNA_PASSO = 96;
COLONNE = 6;

// The fall is swept in steps no larger than this, and capped, or it steps
// clean over the 8 pixel platforms.
PASSO_CADUTA = 3;
VY_MAX = 6;

MURO_SX = 70;                   // ev. 267
MURO_DX = 572;                  // ev. 268
QUOTA_RIENTRO = 500;            // ev. 269: past this it comes back at the top
QUOTA_ALTA = -40;
SOTTO = 240;                    // ev. 281: it only jumps in the lower half

// The original says a jump of -35 and a knockback speed of 30 in its own
// units, which are not this port's. To be tuned.
FORZA_SALTO = -4.6;
GRAVITA = 0.25;
FORZA_SPINTA = 2.5;

// ev. 281 fires every 500 ms, but he counts one to two seconds on a
// platform in the real game: kept as a range, to be tuned.
ATTESA_SALTO_MIN = 0.5;
ATTESA_SALTO_MAX = 1.5;

// Hit, it does not stand there: it hops away at once and keeps hopping for a
// couple of goes, with barely a pause between them.
SALTI_RABBIA_MIN = 2;
SALTI_RABBIA_MAX = 3;
ATTESA_RABBIA = 0.15;

// After a hit it cannot hurt the player for a moment. Without this a headbutt
// from below damaged the dinosaur AND the player in the same step, which made
// them impossible to kill bare handed.
GRAZIA_DANNO = 0.5;
TESTATA_MARGINE = 6;            // how far under the lift the head still counts

ATTESA_SPUTO = 1.0;             // ev. 286: every 1000 ms, one chance in five
PROBABILITA_SPUTO = 5;
PROBABILITA_SPUTO_VICINO = 2;   // within VICINO_SPUTO it spits far more readily
VICINO_SPUTO = 140;             // "within range" for the fireball, wider than VICINO
// The animation speed now lives in the sprites, where it belongs:
// spr_boss_5 5 fps, spr_boss_5_spit 10, spr_boss_5_hit 15. image_speed is
// only a multiplier on top, and leaving it at a fraction was the reason the
// mouth opened and then sat there: 4 frames at 4 fps times 0.25 is one frame
// a second, four seconds for the whole spit.

vy = 0;
vx = 0;
bersaglioX = COLONNA_PRIMA + clamp(round((x - COLONNA_PRIMA) / COLONNA_PASSO), 0, COLONNE - 1) * COLONNA_PASSO;
x = bersaglioX;
attesaSalto = 0;
attesaScelta = random_range(ATTESA_SALTO_MIN, ATTESA_SALTO_MAX);
attesaSputo = 0;
sputando = false;
saltiRabbia = 0;
graziaDanno = 0;
lampeggio = 0;
spinta = 0;
morto = false;
morteTimeout = 0;
musicaMorte = false;
suoloSotto = noone;

// The lava at the bottom. Asked of the room, not written by hand, the same way
// obj_cheep_cheep asks for its water line: the carpet of obj_lava is there and
// the highest of them is the surface. -1 means it has not been found yet, and
// the Step asks again: the answer depends on the lava already existing when
// this Create runs, and an instance creation order is an easy thing to get
// wrong.
quotaLava = -1;
with(obj_lava) {
	if(other.quotaLava == -1 || y < other.quotaLava)
		other.quotaLava = y;
}
eraSottoLava = (quotaLava >= 0 && y > quotaLava);

sprite_index = spr_boss_5;
image_speed = 1;
