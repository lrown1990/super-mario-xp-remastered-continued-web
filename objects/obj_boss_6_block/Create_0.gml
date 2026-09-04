// One of the stone blocks Kamek summons (ev. 291/292 of level 57). In the
// original it is Hai_01, redefined in this level as a 19x19 cluster of four
// stones: it appears with its own animation and then falls.
depth = 25;
sprite_index = spr_boss_6_block_appear;
image_index = 0;
image_speed = 1;
nato = false;                 // still playing the appearing animation
vy = 0;
GRAVITA = 0.25;               // to be tuned, as for the other falling things
VY_MAX = 6;
