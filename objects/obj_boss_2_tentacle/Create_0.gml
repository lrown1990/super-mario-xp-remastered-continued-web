// The tentacle that comes up out of the ground (Boss_02 in the original).
// It does not move at random: it follows the movement recorded in the 2001
// editor, four legs, read out of the file. The durations come from the
// "pixels per second" figures stored with each leg.

depth = 29;

// How far the lunge travels. In the original footage the tip stops at y=138
// with the walkway at y=159, that is 21 pixels above it, and 75 here gives
// exactly that. But in our arena the floor is not at the same height as in
// the video, and in play the tentacle ended up barely above the bridge, so
// it was raised to 95, about twenty pixels higher.
salita = 95;

// MEASURED FROM THE VIDEO. The documented formula gives 375 pixels per
// second; the original does 216, measured across the whole lunge (90 pixels
// from y=228 to y=138, in 10 frames at 23.976 fps). The ratio is 1.74, not
// 2: the first measurement covered only part of the rise and suggested
// "exactly half", but it was incomplete.
rallenta = 1.74;

// leg: [wait BEFORE it, pixels in Y, seconds to travel]
// The original has a single rising leg (75 px) with a 2 second pause. The
// file does not say whether that pause comes before or after. Watching the
// video settles it: the tentacle does NOT rise gradually. It appears already
// at its waiting height, tip at y=230 (ten pixels above the bottom of the
// room), stays there biting for half a second, and THEN makes one single
// lunge of about ninety pixels that brings the tip to y=138. The flower
// creates it already in that position, not lower down.
// The wait at the top was 2.0 seconds, the value from the original movement.
// Lowered to 1.5 at the user's request: half a second less spent biting up
// there before it goes back down. A tentacle's life goes from 4.9 to 4.4
// seconds, and the time its head spends above the bridge floor (y=160) from
// 2.9 to 2.4 seconds.
legs = [
	[0.5, -salita, rallenta * salita / 375],
	[0.0,      -8, rallenta *   8 / 125],
	[0.0,      -6, rallenta *   6 /  62],
	[1.5,     121, rallenta * 121 / 125]
];

segment = 0;
segmentTime = 0;
pauseTime = 0;
startY = y;
dying = false;
paused = false;
