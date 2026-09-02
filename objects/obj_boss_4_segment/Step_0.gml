// The flash when the serpent is hit: in the original ALL nine parts play
// animation 15 together (ev. 166-169), so the head switches this on for
// every link at once.
if(colpito) {
	colpitoTimeout += delta_time / 1000000;
	if(sprite_index != sprite_colpito) {
		sprite_index = sprite_colpito;
		image_index = 0;
		image_speed = 1;
	}
	// six frames at 25 per second, the same as the other bosses
	if(colpitoTimeout > 6 / 25) {
		colpito = false;
		sprite_index = sprite_normale;
		image_speed = 0;
	}
}

// Touching any part of the body hurts, like the head.
if(!global.playerDead && instance_exists(obj_player) && instance_exists(obj_boss_4)) {
	// Shifted DOWN like the head's, so coming down on the serpent never
	// hurts: the links crowd around the head and one of them was catching
	// the player in the very frame he landed the stomp.
	if(obj_boss_4.active && place_meeting(x, y + 10, obj_player) &&
	   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
		mario_damage(3);
}
