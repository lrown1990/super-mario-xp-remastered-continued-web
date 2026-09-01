// Nightmare - the stage 3 boss.
// The numbers come from the original's events, level 31 "3-7", and from
// footage of the real game (JTlpWat59os, 17:56 and 43:01).
// See port/marioxp-originale/BOSS-NIGHTMARE-SPECIFICA.md

depth = 30;

// 30 points in all (ev. 303). Stomp 5, fire 1, hammer 1, cross 2.
damagePoints = 30;

// The original's speeds are in Clickteam units: 2.5 pixels per second per
// unit here. It is the only number to turn if it looks too slow or too
// fast. There are 32 directions, starting from the right and going
// anticlockwise, so they line up with GameMaker's degrees in steps of
// 11.25.
UNITA = 2.5;

// It stays near the top almost all the time and comes down ONLY for the
// dive: outside the attack it never goes past this height.
QUOTA_ALTA = 120;

// How long it stays on the ground after the dive. In the original footage
// it stays down there a long time (six seconds, but the player was filling
// it with crosses). The whole dive - down, stay, back up - has to last 4.10
// seconds, which is what the user asked for to make the boss harder: going
// down and coming back up eat about half a second each, so 3.1 are left on
// the ground.
SECONDI_A_TERRA = 3.1;

velocita = 0;          // pixels per second
angolo = 0;            // degrees, like GameMaker's direction

vagareTimer = 0;
richiamo1Timer = 0;    // the short call, every 8000 ms (ev. 310)
richiamo2Timer = 0;    // the long call, every 12200 ms (ev. 313)

// TWO ATTACKS, and they are the original's two timers:
// - every 8000 ms animation 12 (ev. 310), and that is the one that brings
// it down (ev. 311 moves the Y only while 12 is playing): DIVE. The Boos
// shoot straight out until they leave the room.
// - every 12200 ms animation 13 (ev. 313), which does NOT come down, and is
// the one where the Boos spin around themselves (ev. 325 advances their
// direction by 1/32 of a turn every 200 ms): SPIRAL. It stays up and sends
// them spinning around the room.
//
// vaga | picchiata | aterra | risalita | spirale
// (wander | dive | grounded | rise | spiral)
stato = "vaga";
statoTimer = 0;

// vicino | spirale | fuori (near | spiral | away)
modoBoo = "vicino";

SECONDI_SPIRALE = 3;
quotaPrimaDellaPicchiata = y;

currentAnim = "idle";
animationTimeout = 0;

// The two skeletons parked on the steps stay invisible until 20 seconds
// have passed (ev. 308: switches on the "characters on the ground" group).
scheletriTimer = 0;
scheletriLiberi = false;

// The starting swarm. In the video the orb comes on screen wrapped in a
// cloud of Boos: counted frame by frame there are seventeen or eighteen of
// them, not a dozen as I first said. The ceiling is twenty (ev. 306).
for(var i = 0; i < 18; i++)
	instance_create_layer(x, y, "Objects", obj_boss_3_boo);

active = true;
defeatedTimeout = 0;
defeatedMusic = false;
