// The bolt Kamek throws at the end of his spell (ev. 286/287 of level 57). In
// the original it is Enemy_22, the same rolling flame the dinosaurs of boss 5
// spit, shot at speed 30 — and at 40 for the second one he adds once he is
// angry. It flies straight and does not fall.
depth = 20;
image_speed = 1;
vx = 0;
vy = 0;
// The frames come from direction 0 of the original, that is flying RIGHT, so
// the little flame tail sits on the left. Flying left the sprite has to be
// mirrored or the tail ends up in front of the ball. Whoever creates it sets
// vx first, so the Step does the mirroring on the first step as well.
