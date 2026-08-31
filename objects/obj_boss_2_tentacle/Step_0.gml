var elapsed = delta_time / 1000000;

// decapitato: lo stelo senza testa scende e sparisce
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
		// durante l'attesa morde, col verso vero dell'originale (inpact_15),
		// una volta sola per tentacolo
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

// oltre quota 260 sparisce comunque (ev. 375)
if(!dying && y > 260)
	instance_destroy();

// le tre armi lo abbattono (ev. 377, 378, 379): muore la testa, e lo stelo
// senza testa se ne va verso il basso
if(!dying) {
	// Le armi contano solo sulla TESTA, sul corpo passano attraverso.
	// Riquadro misurato, non stimato: lo sprite con la testa parte a -14
	// dall'origine, quello decapitato a -7, e in basso finiscono uguali.
	// Guardando la larghezza riga per riga, la bocca e' larga fino a -2, a 0
	// si strozza nel collo e da +2 ricomincia la prima foglia: quindi la
	// testa e' tutta la fascia da -14 a 0.
	var tx1 = x - 9, ty1 = y - 14, tx2 = x + 9, ty2 = y;

	var fireTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_fireball, false, true);
	var hammerTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_hammer_player, false, true);
	var crossTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_cross, false, true);

	if(fireTouched || hammerTouched || crossTouched) {
		audio_play_sound(snd_boss_2_tentacle_dead, 1, false);

		// muore la testa: stesso effetto delle piante nei tubi
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
