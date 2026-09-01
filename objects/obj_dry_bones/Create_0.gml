// Dry Bones, the light blue skeleton of stage 3. In the original it is
// Enemy_09. The sprites were ALREADY in the project (spr_dry_bones,
// spr_dry_bones_fall, spr_drybones_defeated, in a folder called "Dry
// Bones") but no object used them: it is the only stage 3 enemy that had
// never been ported. In the original it appears in 3-3, in 3-5 and in the
// boss arena.
//
// Rules, read from level 31's events:
// - fireball: does NOTHING to it, it just fizzles out (ev. 211)
// - stomp and hammer: knock it apart, but it gets back up (ev. 209, 212)
// - cross: actually kills it (ev. 213)

entityDirection = -1;
entitySpeed = 0.4;

currentX = 0;
currentY = 0;

dead = false;        // only exists because obj_enemy_group reads it from outside
defeated = false;    // really dead: the cross only
defeatedYSpeed = 0;   // the bones fall, they do not hop

// Knocked apart. The timings are measured in play against the original: the
// bones lie still for 3 seconds, then rattle, and after 5 in total the
// skeleton is back on its feet. They match the original's data, where the
// pile has a still animation and a nine frame reassembling one.
ossa = false;
ossaTempo = 0;
ossaTremolio = 0;
xFermo = x;

// The ones born outside the walls (the two in the arena, which sit just
// past the doors) have to be able to walk in: until it is inside it does
// not turn around at the wall that closes the room, otherwise it would just
// bounce on the threshold.
entrando = (x < 0 || x > room_width);

onCamera = false;

sprite_index = spr_dry_bones;
