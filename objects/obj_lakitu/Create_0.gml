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

yPoint = -24;
yPointMax = 56;

screenLimit = (room != stage_3_2) ? 16 : 56;

y = camera_get_view_y(view_camera[0]) - 24;

// Horizontal move that will not cross a wall. The cloud used to be steered only
// by the edges of the view: at the start of 6-1 that turn point is x=16, which
// sits inside the 32 pixel wall on the left, so it flew into the stone and let
// its spinies go in there, where they stayed stuck. A solid in the way now
// turns it round instead. A move that starts from inside a solid is still
// allowed, so a cloud that drifted down into one works its way out rather than
// locking in place.
moveHorizontal = function(step) {
	if(step == 0) {
		return;
	}
	
	if(place_meeting(x + step, y, obj_ground_group) && !place_meeting(x, y, obj_ground_group)) {
		entityDirection = -entityDirection;
	} else {
		x += step;
	}
}
