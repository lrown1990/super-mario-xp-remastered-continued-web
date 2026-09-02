// The "killer" that flies in from off camera on the right, as in the 2001
// original. It is not a cannon placed in the room like obj_thrower: there it
// is a marker attached to the SCREEN (the Damy_02 object), so the shot always
// comes from beyond the right edge, at a random height.
//
// Two levels use it and they gate it differently, so everything below is a
// variable definition, set per instance in the room editor:
//
//   3-1 (level 25, ev. 312): Mario between X 1200 and 3000, one shot every
//        3 seconds. Upper band of heights only, by the user's choice: the
//        bottom rows would give a cannon shot you hear and never see,
//        because it passes under the walkways, and in the original that
//        never happened.
//   4-4 (level 37, ev. 296): Mario below Y 600, one shot every 3 seconds,
//        and all SIXTEEN rows of the original, because there the room is one
//        screen wide and the shot crosses it whatever the height it comes in
//        at. It stops in the last stretch of the climb, which is where the
//        fire rods are.
//
// The original's coordinates carry over as they are, because both rooms are
// the same size here as they are there: 3200x240 and 320x2400.
counter = 0;

// The heights come out as "rowFirst + random(rows) * 16", one every 16 pixels
// as in the original, where the marker's Y is "top edge of the screen +
// random(16) * 16 - 8" (ev. 14 of both levels, the same formula in each):
// sixteen rows aligned to the tile grid, the first of them half off the top
// of the screen.
