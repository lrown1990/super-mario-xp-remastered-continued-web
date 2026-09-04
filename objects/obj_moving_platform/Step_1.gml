// global.bossFermo holds the whole room still while a boss defeat plays out
if(!global.playerDead && active && !global.bossFermo) {
	switch(orientation) {
		case "horizontal": {
			if(!place_meeting(x + platformSpeed * plat_direction, y, obj_moving_platform_switch)) {
				x += platformSpeed * plat_direction;
			} else {
				while(!place_meeting(x + sign(platformSpeed * plat_direction), y, obj_moving_platform_switch)) {
					x += sign(platformSpeed * plat_direction);
				}
			
				plat_direction = -plat_direction;
			}
			break;
		}
	
		case "vertical": {
			if(!place_meeting(x, y + platformSpeed * plat_direction, obj_moving_platform_switch)) {
				y += platformSpeed * plat_direction;
			} else {
				while(!place_meeting(x, y + sign(platformSpeed * plat_direction), obj_moving_platform_switch)) {
					y += sign(platformSpeed * plat_direction);
				}
			
				plat_direction = -plat_direction;
			}
			break;
		}
	}
}

// ...and it must not switch itself back on under the player's feet while the
// room is held: that is exactly where he is standing when the fight ends.
if(instance_exists(obj_player) && !global.bossFermo) {
	if(place_meeting(x, y - 1, obj_player) && !active) {
		active = true;
	}
}

if(y > room_height + 6 && has_teleport)
	y = -6;