// outside the play area it disappears (ev. 384)
if(y > room_height + 16 || x < -16 || x > room_width + 16)
	instance_destroy();

if(instance_exists(obj_player) && place_meeting(x, y, obj_player)
   && !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(3);
