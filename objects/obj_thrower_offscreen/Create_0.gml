// The "killer" that flies in from the right in mid air in 3-1, as in the
// 2001 original: level 25 ("3-1"), キラー event group, event 312. It is not a
// cannon placed in the room like obj_thrower: in the original it is a
// marker attached to the SCREEN (the Damy_02 object), so the shot always
// comes from off camera on the right, at a random height.
counter = 0;

// The stretch where it happens: Mario between X 1200 and 3000 (ev. 312).
// The original's coordinates carry over as they are, because there the room
// is 3200x240, which is exactly the size of this one.
fromX = 1200;
toX = 3000;

// One shot every 3 seconds (ev. 312, "every 3000 ms"). It is also the rate
// of the cannons already in the game, obj_thrower.
period = 3;

// The possible heights, one every 16 pixels as in the original, where the
// marker's Y is "top edge of the screen + random(16) * 16 - 8" (ev. 14):
// sixteen rows aligned to the tile grid.
// HERE THOUGH ONLY THE UPPER BAND, by the user's choice: the bottom rows
// would give a cannon shot you hear and never see, because it passes under
// the platforms, and in the original that never happened. The original's
// first row (-8) would also be half off the top of the screen.
// Ten heights are left, from 8 to 152: all inside the view and all level
// with the walkways along this stretch, which sit between 96 and 160. To
// widen or narrow the band, only these two lines need touching.
rowFirst = 8;
rows = 10;
