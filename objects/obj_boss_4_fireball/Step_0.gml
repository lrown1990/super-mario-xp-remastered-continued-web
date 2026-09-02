if(global.playerDead) {
	image_speed = 0;
	return;
}

x += vx * (delta_time / 1000000);
y += vy * (delta_time / 1000000);

// out of the room and it is gone
if(x < -32 || x > room_width + 32 || y < -48 || y > room_height + 48) {
	instance_destroy();
	return;
}

if(instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
