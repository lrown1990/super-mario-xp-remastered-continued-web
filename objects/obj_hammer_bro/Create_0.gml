entityDirection = -1;
entitySpeed = 0.5;

currentX = 0;
currentY = 0;

dead = false;
defeated = false;
deadTimeout = 0;

defeatedYSpeed = -5.2;

jumped = false;
jumpTimeout = 0;

jumpStrength = 0;

hammerThrown = false;

aimDirection = -1;

initialX = x;

// The edges of the map are a wall for it, and the patrol band is pushed inside
// them. Not only so it does not walk out of the level: the onCamera test at the
// top of the Step counts 32 pixels IN from the left of the view, so one
// standing in that strip counts as off screen, and off screen a hammer bro
// neither moves nor throws. At the end of 6-3 its band was 0..64, right inside
// that strip: it walked into the level exit, froze there and stopped throwing.
// Turning it round would not have been enough, because frozen it could not
// have walked back out either: it must never get in.
MARGINE_BORDO = 32 + sprite_width / 2;
if(initialX - 64 < MARGINE_BORDO) initialX = MARGINE_BORDO + 64;
if(initialX > room_width - MARGINE_BORDO) initialX = room_width - MARGINE_BORDO;