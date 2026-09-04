onCamera =  (x - sprite_width / 2) < (camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])) + 32 && 
			(x + sprite_width / 2) > camera_get_view_x(view_camera[0]) + 32 &&
			(y - sprite_height - 92) < (camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])) &&
			(y + sprite_height + 92 > camera_get_view_y(view_camera[0]));
if(entityDirection == -1 && 
   (onCamera || !inactive_offscreen) &&
   !dead &&
   !defeated &&
   !global.playerDead
){
	currentX = -entitySpeed;
	x += currentX;
} else if(
   entityDirection == 1 && 
   (onCamera || !inactive_offscreen) &&
   !dead &&
   !defeated &&
   !global.playerDead
) {
	currentX = entitySpeed;
	x += currentX;
}

if(defeated && y > room_height + sprite_height) {
	instance_destroy();
}

if(instance_exists(obj_player) && !defeated && x != obj_player.x) {
	aimDirection = sign(obj_player.x - x);
}

image_xscale = aimDirection;

if(place_meeting(x, y - 1, obj_player) && !dead && !defeated && !global.jumpHold && !obj_player.onGround && obj_player.y < (y - sprite_height / 2) && obj_player.currentY > 0) {
	defeated = true;
	audio_play_sound(snd_enemy_defeat, 1, false);
	sprite_index = spr_hammer_bro_dead;
	obj_player.currentY = -1.5;
	obj_player.enemyBounce += 1;
	check_bounce();
} else if(place_meeting(x, y - 1, obj_player) && !dead && !defeated && global.jumpHold && !obj_player.onGround && obj_player.y < (y - sprite_height / 2) && obj_player.currentY > 0) {
	defeated = true;
	audio_play_sound(snd_enemy_defeat, 1, false);
	sprite_index = spr_hammer_bro_dead;
	obj_player.currentY = -5;
	obj_player.enemyBounce += 1;
	check_bounce();
} else if(place_meeting(x, y, obj_player) && !dead && !defeated && !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash) {
	mario_damage(3);
}

if(dead) {
	deadTimeout += delta_time / 1000000;
		
	if(deadTimeout > 0.5)
		instance_destroy();
}

if(x > initialX - 64 && entityDirection == -1) {
	currentX = -1;
} else if(x < initialX && entityDirection == 1) {
	currentX = 1;
}

if(x < initialX - 64 && entityDirection == -1) {
	entityDirection = 1;
} else if(x > initialX && entityDirection == 1) {
	entityDirection = -1;
}

// And if something shoves it out of the band anyway (a goomba underfoot moves
// it 8 pixels sideways), it gets put back inside rather than left frozen in the
// corner. See the note in the Create for why the margin is what it is.
if(x < MARGINE_BORDO) {
	x = MARGINE_BORDO;
	entityDirection = 1;
} else if(x > room_width - MARGINE_BORDO) {
	x = room_width - MARGINE_BORDO;
	entityDirection = -1;
}

if(defeated && !global.playerDead) {
	y += defeatedYSpeed;
	defeatedYSpeed += 0.22;
}

if(!defeated && !dead) {
	var hammerTouched = instance_place(x, y, obj_hammer_player);
	var fireTouched = instance_place(x, y, obj_fireball);
	var crossTouched = instance_place(x, y, obj_cross);
	
	var blockTouched = instance_place(x, y, obj_block_hit_detector);
	var brickTouched = instance_place(x, y, obj_block_hit_detector);
	
	var goomba = instance_place(x, y + 6, obj_goomba);
	var koopa = instance_place(x, y + 1, obj_koopa);
	var paratroopa = instance_place(x, y + 1, obj_paratroopa_path);
	
	if(hammerTouched) {
		defeated = true;
		hammerTouched.initial_vertical = -2.5;
		audio_play_sound(snd_enemy_defeat, 1, false);
		sprite_index = spr_hammer_bro_dead;
	}
	
	if(fireTouched) {
		defeated = true;
		audio_play_sound(snd_enemy_defeat, 1, false);
		sprite_index = spr_hammer_bro_dead;
		var instance = instance_create_layer(fireTouched.x, fireTouched.y, "Objects", obj_fireball_explosion);
		instance.emitter = fireTouched.emitter;
		instance_destroy(fireTouched);
	}
	
	if(crossTouched) {
		defeated = true;
		audio_play_sound(snd_enemy_defeat, 1, false);
		sprite_index = spr_hammer_bro_dead;
	}
	
	if(blockTouched) {
		defeated = true;
		audio_stop_sound(snd_enemy_defeat);
		audio_play_sound(snd_enemy_defeat, 1, false);
		sprite_index = spr_hammer_bro_dead;
}
	
	if(brickTouched) {
		defeated = true;
		audio_stop_sound(snd_enemy_defeat);
		audio_play_sound(snd_enemy_defeat, 1, false);
		sprite_index = spr_hammer_bro_dead;
	}
	
	if(goomba) {
		if(!goomba.dead && goomba.currentY >= 1) {
			x += 8;
			goomba.x -= 8;
		}
	}
	
	if(koopa) {	
		if(koopa.shellMoving) {
			defeated = true;
			audio_play_sound(snd_enemy_defeat, 1, false);
			sprite_index = spr_hammer_bro_dead;
		}
	}
	
	if(paratroopa) {	
		if(paratroopa.shellMoving) {
			defeated = true;
			audio_play_sound(snd_enemy_defeat, 1, false);
			sprite_index = spr_hammer_bro_dead;
		}
	}
}

if(!defeated) {
	if(place_meeting(x + currentX, y, obj_ground_group)) {
		// Turn AWAY from the wall, do not invert. The patrol bound just above
		// flips the direction on its own when x leaves the initialX-64..initialX
		// band, and inverting on top of that flip pointed the hammer bro back
		// into the wall: the two cancelled each other out every step and it
		// walked straight through, half a pixel at a time. That is how the one
		// in 5-3 ended up inside the pillar at x=304, which sits exactly on its
		// left patrol bound.
		entityDirection = currentX < 0 ? 1 : -1;
	} else {
		instance = instance_place(x + currentX, y, obj_enemy_group);
		if(instance != noone && !instance.dead && !instance.defeated) {
			entityDirection = -entityDirection;
		
			while(!instance.onCamera && place_meeting(x, y, obj_enemy_group)){
				instance.x -= 1;
			}
		}
	}
}

if(defeated && !global.playerDead) {
	image_angle = image_angle + 16 * aimDirection;
}

if((onCamera || !inactive_offscreen) && !global.playerDead && !defeated) {
	currentY += 0.20;
	
	if(!place_meeting(x, y + currentY, obj_ground_group)) {
		y += currentY;
	} else {
		if(currentY < 0) {
			// Going up. This used to move through ANY solid, so the hammer bro
			// climbed into walls: once its mask overlapped one it also counted
			// as standing on it, could jump again from mid air, and ended up
			// floating on the far side (the pillar at x=304 in 5-3).
			// Bricks stay passable on the way up on purpose: the falling
			// branch below already drops through them on the short hop, which
			// is the Hammer Bro's own move and is what 3-1, 4-1 and 6-1 are
			// built around.
			if(place_meeting(x, y + currentY, obj_brick)) {
				y += currentY;
			} else {
				while(!place_meeting(x, y - 1, obj_ground_group)) {
					y -= 1;
				}

				currentY = 0;
			}
		} else {
			if(jumpStrength != 1 ) {
				while(!place_meeting(x, y + sign(currentY), obj_ground_group)) {
					y += sign(currentY);
				}
	
				currentY = 0;
				jumpStrength = 0;	
			} else {
				if(!place_meeting(x, y + currentY, obj_ground_group)) {
					y += currentY;
				} else {
					if(place_meeting(x, y + currentY, obj_brick)) {
						y += currentY;
					} else {
						while(!place_meeting(x, y + sign(currentY), obj_ground_group)) {
							y += sign(currentY);
						}
	
						currentY = 0;
						jumpStrength = 0;	
					}
				}
			}
		}
	}
	
	jumpTimeout += delta_time / 1000000;
	
	if(jumpTimeout >= 2 && place_meeting(x, y + 1, obj_ground_group)) {
		jumpStrength = irandom_range(1, 2);
		jumpTimeout = 0;
		
		switch(jumpStrength) {
			case 1: {
				currentY = -2.2;
				break;
			}
			
			case 2: {
				currentY = -5.4;
				break;
			}
		}
	}
	
	if(!hammerThrown && image_index >= 2 && image_index <= 3) {
		hammerThrown = true;
		audio_play_sound(snd_throw, 1, false);
		var hammer = instance_create_layer(x + (8 * aimDirection), y - 16, "Objects", obj_hammer_enemy);
		hammer.initial_horizontal = random_range(0.6,3) * aimDirection;
		hammer.hammer_direction = aimDirection;
	} else if(hammerThrown && image_index < 2) {
		hammerThrown = false;
	}
}

if(global.playerDead) {
	image_speed = 0;
}