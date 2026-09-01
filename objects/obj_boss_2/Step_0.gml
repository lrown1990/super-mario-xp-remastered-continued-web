if(!global.playerDead && instance_exists(obj_player)) {
	if(active) {
		var elapsed = delta_time / 1000000;

		if(!sinking) {
			// chases Mario 1 pixel every 100 ms, between X 60 and 900 (ev.
			// 357, 358)
			chaseTimer += elapsed;
			while(chaseTimer >= 0.1) {
				chaseTimer -= 0.1;

				if(x > obj_player.x && x > 60)
					x -= 1;
				else if(x < obj_player.x && x < 900)
					x += 1;
			}

			// rises until it reaches height 160 (ev. 359)
			if(y > riseLimit) {
				y -= 1;

				// while it is still rising the dive timer does not run: it
				// has to count from the moment the flower reaches the
				// bridge, otherwise it dives while still below
				slamTimer = 0;
			} else {
				// once up there it bobs 13 pixels at 12 pixels per second:
				// that is the movement recorded in the original, a single
				// leg looping with a reverse at the end
				bobTime += elapsed;
				y = riseLimit - abs(((bobTime * 12) mod 26) - 13);

				// It drops down: in the original (ev. 382) this is a flat
				// "every 3000 ms", here the wait is drawn at random around
				// that value each time, so the player cannot count the
				// beat.
				slamTimer += elapsed;
				if(slamTimer >= slamDelay) {
					slamTimer = 0;
					slamDelay = random_range(1.0, 3.0);
					sinking = true;
					slammed = false;
					fallSpeed = 0;
					audio_play_sound(snd_boss_2_sink, 1, false);
				}
			}

		} else {
			// falls with acceleration (ev. 360). Once hit it flees: it
			// drops faster and swerves sideways, left or right at random
			fallSpeed += 0.5;
			y += fallSpeed / 2;

			if(fleeDir != 0) {
				x = clamp(x + fleeDir * 1.5, 60, 900);
			}

			// on hitting the ground it throws four spores (ev. 383)
			if(!slammed && place_meeting(x, y + 1, obj_ground_group)) {
				slammed = true;
				audio_play_sound(snd_boss_2_land, 1, false);

				// Four spores, and the spread is NOT invented: the
				// direction mask in event 383 is 0x1ff0, that is directions
				// 4 to 12 out of Clickteam's 32, from 45 to 135 degrees in
				// steps of 11.25. The game draws one of them per spore.
				//
				// The base push is "15 + random(10)" in Clickteam units.
				// The documented rate of 6.25 pixels per second per unit is
				// for recorded MOVEMENTS, not for a thrown object: at that
				// value the top of the arc came out at 17 pixels and the
				// flower was dropping the spores on its own head. SPINTA is
				// the multiplier tuned by eye, and it is the only number to
				// turn if the arc does not look right (at 1.45 with gravity
				// 0.08 the top sits between 32 and 88 pixels, but the arc
				// is slower both up and down).
				var SPINTA = 1.45;

				for(var i = 0; i < 4; i++) {
					var spore = instance_create_layer(x, y, "Objects", obj_boss_2_spore);
					spore.direction = 45 + irandom(8) * 11.25;
					spore.speed = (15 + irandom(10)) * 6.25 / 60 * SPINTA;
				}
			}

			// below height 260 it comes back up at a random X (ev. 361)
			if(y > sinkLimit) {
				x = 40 + irandom(880);
				y = sinkLimit;
				fallSpeed = 0;
				sinking = false;
				fleeDir = 0;
				image_index = 0;
			}
		}

		// tentacles come up faster the more damage it has taken (ev. 370,
		// 371, 372)
		var taken = 18 - damagePoints;
		var tentacleDelay = 1.8;
		if(taken >= 12)
			tentacleDelay = 0.6;
		else if(taken >= 6)
			tentacleDelay = 1.1;

		// they come out of the ground at a random X INSIDE THE VIEW, not
		// out of the flower: in the original ev. 15 keeps moving the marker
		// to "left edge of the screen + random(320)"
		tentacleTimer += elapsed;
		if(tentacleTimer >= tentacleDelay) {
			tentacleTimer = 0;

			// It is born already at the original's waiting height: tip at
			// y=230, measured from the video. The sprite origin sits 14
			// pixels below the tip, so the object goes at 244.
			//
			// The X is drawn inside the view (ev. 15), but kept to the
			// bridge area: the limits 60 and 900 are the same ones the
			// original keeps the flower within (ev. 357 and 358), that is
			// the playable stretch between the entrance and the exit.
			var viewX = camera_get_view_x(view_camera[0]);
			var x1 = max(viewX, 60);
			var x2 = min(viewX + 320, 900);

			if(x2 > x1)
				instance_create_layer(x1 + irandom(x2 - x1), 244, "Objects", obj_boss_2_tentacle);
		}

		// Weapons only count if they hit the FLOWER, not the leaves. The
		// box is measured off the sprite: in the original the flower's red
		// pixels sit at x 33..57 and y 4..13 of a 90x120 drawing with its
		// origin at (44,24), which is what is below, plus a few pixels of
		// slack.
		var tx1 = x - 13, ty1 = y - 22, tx2 = x + 15, ty2 = y - 8;

		var fireTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_fireball, false, true);
		var hammerTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_hammer_player, false, true);
		var crossTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_cross, false, true);

		// Stomp: 2 points (ev. 363). Only on the flower, not on the leaves,
		// which are fronds and cannot be stood on. Same box as the weapons.
		if(collision_rectangle(tx1, ty1 - max(obj_player.currentY, 0), tx2, ty2, obj_player, false, true)
		   && !place_meeting(x, y + 10, obj_player)) {
			if(currentAnim != "damaged") {
				audio_play_sound(snd_boss_2_stomp, 1, false);
				audio_play_sound(snd_boss_2_hit, 1, false);
				currentAnim = "damaged";
				animationTimeout = 0;
				damagePoints -= 2;
				sinking = true;
				slamTimer = 0;
				fleeDir = choose(-1, 1);
			}

			if(global.jumpHold)
				obj_player.currentY = -7.5;
			else
				obj_player.currentY = -4;
			obj_player.y = bbox_top;
		}

		// fireball and hammer: 1 point. cross: 2 (ev. 364, 365, 366)
		if(fireTouched && currentAnim != "damaged") {
			var instance = instance_create_layer(fireTouched.x, fireTouched.y, "Objects", obj_fireball_explosion);
			instance.emitter = fireTouched.emitter;
			instance_destroy(fireTouched);

			audio_play_sound(snd_boss_2_weapon, 1, false);
			audio_play_sound(snd_boss_2_hit, 1, false);
			currentAnim = "damaged";
			animationTimeout = 0;
			damagePoints -= 1;
			sinking = true;
			slamTimer = 0;
			fleeDir = choose(-1, 1);
		}

		if(hammerTouched && currentAnim != "damaged") {
			hammerTouched.initial_vertical = -2.5;

			audio_play_sound(snd_boss_2_weapon, 1, false);
			audio_play_sound(snd_boss_2_hit, 1, false);
			currentAnim = "damaged";
			animationTimeout = 0;
			damagePoints -= 1;
			sinking = true;
			slamTimer = 0;
			fleeDir = choose(-1, 1);
		}

		if(crossTouched && currentAnim != "damaged") {
			audio_play_sound(snd_boss_2_weapon, 1, false);
			audio_play_sound(snd_boss_2_hit, 1, false);
			currentAnim = "damaged";
			animationTimeout = 0;
			damagePoints -= 2;
			sinking = true;
			slamTimer = 0;
			fleeDir = choose(-1, 1);
		}

		if(place_meeting(x, y + 10, obj_player) && !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
			mario_damage(3);

		if(currentAnim == "damaged") {
			animationTimeout += elapsed;
			sprite_index = spr_boss_2_damaged;

			if(animationTimeout > 0.6) {
				currentAnim = "idle";
				sprite_index = spr_boss_2_idle;
			}
		}

		if(x < 60)
			x = 60;

		if(x > 900)
			x = 900;

		if(damagePoints <= 0) {
			active = false;

			// the screen exit stays disabled afterwards too: once the boss
			// is beaten the game moves on to the next stage by itself, and
			// switching it back on only made its green rectangle show up
			// again in the bottom right
			audio_stop_sound(global.bgm_boss_intro);
			audio_stop_sound(global.bgm_boss_loop);
			audio_sound_gain(global.bgm_boss_loop, 0, 0);
			audio_play_sound(snd_impact_generic, 1, false);

			image_index = 0;
			sprite_index = spr_boss_2_defeat;

			// the tentacles do not just vanish: they all die together as if
			// they had been hit at the same instant, each with its own
			// effect, and the headless stalk sinks away downwards
			with(obj_boss_2_tentacle) {
				if(!dying) {
					instance_create_layer(x, bbox_top + 8, "Objects", obj_piranha_plant_defeated);
					dying = true;
					sprite_index = spr_boss_2_tentacle_dead;
				}
			}

			audio_play_sound(snd_boss_2_tentacle_dead, 1, false);
			with(obj_boss_2_spore)
				instance_destroy();
		}
	} else {
		defeatedTimeout += delta_time / 1000000;

		if(image_index >= image_number - 1)
			sprite_index = noone;

		if(defeatedTimeout > 1 && !defeatedMusic) {
			defeatedMusic = true;
			audio_play_sound(global.bgm_boss_defeated, 1, false);
		}

		if(defeatedTimeout > 5.5) {
			audio_sound_gain(global.bgm_boss_loop, 1, 0);
			global.currentStage = 3;
			level_finished(global.currentStage, global.playerWeapon, global.hearts, global.pHealth);
			room_goto(stage_intro);
		}
	}
} else {
	image_speed = 0;
}
