// The red spore: four of them are thrown when the flower slams down (ev. 383).
// direction and speed are set by the flower when it creates them.

depth = 28;

// they are fired upwards and gravity brings them back down: that is the arc
// you see in the original. Gravity is low on purpose, so the spore floats
// instead of dropping like a stone. If you change it, recompute SPINTA in
// obj_boss_2: the height of the arc is SPINTA squared over twice this value.
gravity_direction = 270;
gravity = 0.08;
