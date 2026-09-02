if(instance_exists(obj_player)) {
	entity_direction = sign(obj_player.x - x);
	
	if(abs(obj_player.x - x) < 100) {
		xSpeed = random_range(1, 1.25);
		ySpeed = random_range(-7, -6);
	} else {
		xSpeed = random_range(2, 3);
		ySpeed = random_range(-7, -5.6);
	}
} else {
	entity_direction = 0
	xSpeed = 0;
	ySpeed = 0;
}
dead = false;

// Where the surface is, so it can throw up a plume going out and coming back.
// It is asked of the room, not set by hand: the levels with water have a
// carpet of obj_water and the ones without have none, and in those - the
// bridge in 2-3, for instance - there is no splash sound either, so there
// must be no plume. -1 means "no water here".
quotaAcqua = -1;
with(obj_water) {
	if(other.quotaAcqua == -1 || y < other.quotaAcqua)
		other.quotaAcqua = y;
}
eraSottAcqua = (quotaAcqua >= 0 && y > quotaAcqua);

if(entity_direction == 0)
	entity_direction = 1;