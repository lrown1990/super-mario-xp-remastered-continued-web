if(global.playerDead) {
	image_speed = 0;
	return;
}

// ev. 293: when the appearing animation ends it drops to the still frame, and
// only then does it start to fall.
if(!nato) {
	if(image_index >= image_number - 1) {
		nato = true;
		sprite_index = spr_boss_6_block;
		image_index = 0;
		image_speed = 0;
	}
	return;
}

vy = min(vy + GRAVITA, VY_MAX);
y += vy;

// ev. 115: touching the background it breaks into four shards thrown upwards
// at speeds 20, 25, 30 and 35 in the original's units, and is gone.
if(place_meeting(x, y + 1, obj_ground_group) || y > room_height + 32) {
	if(y <= room_height + 32) {
		audio_play_sound(snd_stone_break, 1, false);   // "inpact_05"
		for(var k = 0; k < 4; k++) {
			var c = instance_create_layer(x, y, "Objects", obj_boss_6_block_piece);
			c.vy = -(2 + k * 0.5);
			c.vx = random_range(-1.5, 1.5);
		}
	}
	instance_destroy();
	return;
}

// The original has no event of its own for this: the block belongs to the
// enemy qualifier, which is what events 23 and 24 use to take hearts off the
// player. Two hearts is what that qualifier costs.
if(instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(2);
