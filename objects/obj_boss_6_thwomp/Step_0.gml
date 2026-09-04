if(global.playerDead) return;

if(verso == 1) {
	sprite_index = spr_thwomp_down;
	if(place_meeting(x, y + VELOCITA_GIU, obj_ground_group)) {
		while(!place_meeting(x, y + 1, obj_ground_group)) y += 1;
		verso = -1;
		audio_play_sound(snd_impact_generic, 1, false);   // "inpact_10", ev. 297
	} else {
		y += VELOCITA_GIU;
	}
} else {
	sprite_index = spr_thwomp_up;
	y -= VELOCITA_SU;
	// ev. 298: back home it stops, and while it is away Kamek cannot summon it
	// again. Here "gone" is what frees the summon, so it simply leaves.
	if(y < -48) {
		instance_destroy();
		return;
	}
}

if(instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(3);
