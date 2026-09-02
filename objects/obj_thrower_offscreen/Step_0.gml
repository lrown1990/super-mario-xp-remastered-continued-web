if(!instance_exists(obj_player))
	return;

// Outside the stretch the count stands still, as in obj_thrower when the
// cannon is off camera: it does not restart from scratch, it picks up where
// it was. A level gates on one axis and leaves the other wide open: 3-1 walks
// along X, 4-4 climbs along Y.
if(obj_player.x >= fromX && obj_player.x <= toX &&
   obj_player.y >= fromY && obj_player.y <= toY)
	counter += delta_time / 1000000;

if(counter >= period) {
	counter = 0;

	var vx = camera_get_view_x(view_camera[0]);
	var vy = camera_get_view_y(view_camera[0]);
	var vw = camera_get_view_width(view_camera[0]);

	// Just past the right edge, and STRICTLY by a little. obj_bullet_bill
	// destroys itself as soon as it leaves the view, and the margin it
	// allows itself is "sprite_width + 32". That is the SCALED sprite
	// though, and as soon as the bullet aims left image_xscale becomes -1:
	// the margin flips over and turns into a tolerance of just 14 pixels.
	// Born at +20 it vanished on the second step, before it even came into
	// shot (measured: zero live bullets in forty seconds of testing). At +8
	// the bullet comes in over the edge and stays.
	// The facing is not set here: obj_bullet_bill's Create aims at Mario,
	// who from this position is always to the left.
	instance_create_layer(vx + vw + 8, vy + rowFirst + irandom(rows - 1) * 16, "Objects", obj_bullet_bill);

	audio_play_sound(snd_impact_generic, 1, false);
}
