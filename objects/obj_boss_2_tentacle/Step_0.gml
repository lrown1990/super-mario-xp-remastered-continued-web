var elapsed = delta_time / 1000000;

// beheaded: the headless stalk sinks away and disappears
if(dying) {
	y += 3;

	if(y > 280)
		instance_destroy();
} else if(segment < array_length(legs)) {
	var leg = legs[segment];

	if(!paused && leg[0] > 0) {
		paused = true;
		pauseTime = leg[0];
	}

	if(pauseTime > 0) {
		// while waiting it bites, with the real sound from the original
		// (inpact_15), once per tentacle
		pauseTime -= elapsed;

		if(sprite_index != spr_boss_2_tentacle_bite) {
			sprite_index = spr_boss_2_tentacle_bite;
			audio_play_sound(snd_boss_2_bite, 1, false);
		}
	} else {
		sprite_index = spr_boss_2_tentacle;

		segmentTime += elapsed;
		var t = min(segmentTime / leg[2], 1);
		y = startY + leg[1] * t;

		if(t >= 1) {
			segment += 1;
			segmentTime = 0;
			startY = y;
			paused = false;
		}
	}
} else {
	instance_destroy();
}

// past height 260 it disappears anyway (ev. 375)
if(!dying && y > 260)
	instance_destroy();

// the three weapons bring it down (ev. 377, 378, 379): the head dies, and
// the headless stalk sinks away downwards
if(!dying) {
	// Weapons only count on the HEAD, through the body they pass straight
	// through. The box is measured, not guessed: the sprite with the head
	// starts at -14 from the origin, the beheaded one at -7, and they end
	// at the same place at the bottom. Reading the width row by row, the
	// mouth is wide down to -2, at 0 it narrows into the neck and from +2
	// the first leaf begins: so the head is the whole band from -14 to 0.
	var tx1 = x - 9, ty1 = y - 14, tx2 = x + 9, ty2 = y;

	var fireTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_fireball, false, true);
	var hammerTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_hammer_player, false, true);
	var crossTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_cross, false, true);

	if(fireTouched || hammerTouched || crossTouched) {
		audio_play_sound(snd_boss_2_tentacle_dead, 1, false);

		// the head dies: same effect as the piranha plants in the pipes
		instance_create_layer(x, bbox_top + 8, "Objects", obj_piranha_plant_defeated);

		if(hammerTouched)
			hammerTouched.initial_vertical = -2.5;

		if(fireTouched) {
			var instance = instance_create_layer(fireTouched.x, fireTouched.y, "Objects", obj_fireball_explosion);
			instance.emitter = fireTouched.emitter;
			instance_destroy(fireTouched);
		}

		dying = true;
		sprite_index = spr_boss_2_tentacle_dead;
	}

	if(instance_exists(obj_player) && place_meeting(x, y, obj_player)
	   && !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
		mario_damage(3);
}
