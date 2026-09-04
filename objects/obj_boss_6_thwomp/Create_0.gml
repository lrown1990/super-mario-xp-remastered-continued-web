// The Thwomp Kamek drops on the player (ev. 296-298 of level 57). In the
// original it is Enemy_23, parked above the room, moved onto Mario's x and
// launched at speed 50; on hitting the background it turns round and goes back
// up at speed 8, and stops when it is home — which is what gates the next
// summon, since ev. 295 asks for its movement to have stopped.
// The two speeds are this port's own thwomp ones (obj_thwomp: 3 pixels a step
// down, 0.75 up), which read the original's 50 and 8 the same way.
depth = 25;
sprite_index = spr_thwomp_down;
image_speed = 0;
VELOCITA_GIU = 3;
VELOCITA_SU = 0.75;
verso = 1;
