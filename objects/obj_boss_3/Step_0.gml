if(!global.playerDead && instance_exists(obj_player)) {
	if(active) {
		var elapsed = delta_time / 1000000;

		// At exactly 20 seconds the two skeletons appear (ev. 308).
		if(!scheletriLiberi) {
			scheletriTimer += elapsed;
			if(scheletriTimer >= 20) {
				scheletriLiberi = true;
				with(obj_dry_bones)
					dormiente = false;
			}
		}

		switch(stato) {

			// ---- VAGA (wander)
			// ----------------------------------------------
			// It stays up high and drifts. From a standstill, every 500 ms
			// it picks a random one of the 32 directions and speed 5 (ev.
			// 292); after that it keeps that speed, and hits change it.
			case "vaga": {
				if(velocita == 0) {
					vagareTimer += elapsed;
					if(vagareTimer >= 0.5) {
						vagareTimer = 0;
						angolo = irandom(31) * 11.25;
						velocita = 5 * UNITA;
					}
				} else {
					// the dive timers only run while it is moving
					var attacca = -1;
					richiamo1Timer += elapsed;
					richiamo2Timer += elapsed;

					if(richiamo1Timer >= 8) {
						richiamo1Timer = 0;
						attacca = 0;
					} else if(richiamo2Timer >= 12.2) {
						richiamo2Timer = 0;
						attacca = 1;
					}

					if(attacca >= 0) {
						quotaPrimaDellaPicchiata = y;
						velocita = 0;
						statoTimer = 0;
						image_index = 0;
						image_speed = 2;   // the attack animation runs at double speed
						audio_play_sound(snd_boss_3_summon, 1, false);

						// 0 = the dive, 1 = the spiral
						stato = (attacca == 0) ? "picchiata" : "spirale";

						if(stato == "spirale")
							modoBoo = "spirale";

						// The attack tops the swarm back up (ev. 310, 313,
						// 320; ceiling of twenty from ev. 306).
						var quanti = (attacca == 1) ? 3 : 2;
						repeat(quanti) {
							if(instance_number(obj_boss_3_boo) < 20)
								instance_create_layer(x, y, "Objects", obj_boss_3_boo);
						}
					}
				}

				// If a hit has left it below its own height, it climbs back
				// up instead of staying there to be stomped.
				if(y > QUOTA_ALTA + 4 && velocita > 0)
					angolo = 90;

				// movement and bounce (ev. 294, 295), one axis at a time
				if(velocita > 0) {
					var dx = lengthdir_x(velocita * elapsed, angolo);
					var dy = lengthdir_y(velocita * elapsed, angolo);

					if(place_meeting(x + dx, y, obj_ground_group) || x + dx < 8 || x + dx > room_width - 8) {
						angolo = 180 - angolo;
						dx = -dx;
					}

					// The floor it bounces off is not the real one: it is
					// the high line. Outside the attack it never goes
					// lower.
					if(place_meeting(x, y + dy, obj_ground_group) || y + dy < 8 || y + dy > QUOTA_ALTA) {
						angolo = -angolo;
						dy = -dy;
					}

					x += dx;
					y += dy;
				}
				break;
			}

			// ---- PICCHIATA (dive)
			// -------------------------------------------
			// It drops straight down at 3 pixels per step (ev. 311). The
			// original runs at 50 frames per second, so 150 pixels per
			// second: from the top to the floor takes about a second. It
			// ends when it arrives, not on a timer.
			case "picchiata": {
				y = min(196, y + 150 * elapsed);

				if(y >= 196) {
					stato = "aterra";
					statoTimer = 0;
					angolo = choose(0, 180);
					velocita = 5 * UNITA;

					// Once it touches the ground it flings them straight
					// out, until they leave the room.
					modoBoo = "fuori";
				}
				break;
			}

			// ---- A TERRA (grounded)
			// -----------------------------------------
			// It stays down for a few seconds, sliding along the floor.
			case "aterra": {
				statoTimer += elapsed;

				var dx = lengthdir_x(velocita * elapsed, angolo);
				if(place_meeting(x + dx, y, obj_ground_group) || x + dx < 8 || x + dx > room_width - 8) {
					angolo = 180 - angolo;
					dx = -dx;
				}
				x += dx;

				if(statoTimer >= SECONDI_A_TERRA) {
					stato = "risalita";
					image_speed = 1;
				}
				break;
			}

			// ---- SPIRALE (spiral)
			// -------------------------------------------
			// The other attack: it stays where it is, makes its sound and
			// sends the Boos spinning around the room. When it is done it
			// calls them back.
			case "spirale": {
				statoTimer += elapsed;

				if(statoTimer >= SECONDI_SPIRALE) {
					stato = "vaga";
					modoBoo = "vicino";
					velocita = 0;
					vagareTimer = 0;
					image_speed = 1;
				}
				break;
			}

			// ---- RISALITA (rise)
			// --------------------------------------------
			// It goes back up to the height it started from, calling the
			// Boos in on the way.
			case "risalita": {
				y = max(quotaPrimaDellaPicchiata, y - 150 * elapsed);

				modoBoo = "vicino";

				// If it has been hit it carries the sideways knock with it:
				// it flees diagonally, not just straight up.
				if(velocita > 0) {
					var dx = lengthdir_x(velocita * elapsed, angolo);
					if(place_meeting(x + dx, y, obj_ground_group) || x + dx < 8 || x + dx > room_width - 8) {
						angolo = 180 - angolo;
						dx = -dx;
					}
					x += dx;
				}

				if(y <= quotaPrimaDellaPicchiata) {
					stato = "vaga";
					velocita = 0;
					vagareTimer = 0;
				}
				break;
			}
		}

		// ---- the hits
		// ------------------------------------------------------
		var fuoco = instance_place(x, y, obj_fireball);
		var martello = instance_place(x, y, obj_hammer_player);
		var croce = instance_place(x, y, obj_cross);

		// Stomp: 5 points (ev. 297 and 298), and the orb is knocked away to
		// the opposite side from Mario. In the original the condition is
		// that Mario is in his jump animation and that the orb's Y is below
		// his: here the same test the other two bosses use applies.
		if(place_meeting(x, y - obj_player.currentY, obj_player) && !place_meeting(x, y + 10, obj_player)) {
			if(currentAnim != "damaged") {
				audio_play_sound(snd_boss_2_stomp, 1, false);   // this is inpact_03, shared by the three bosses
				audio_play_sound(snd_boss_3_hit, 1, false);
				currentAnim = "damaged";
				animationTimeout = 0;
				image_index = 0;
				damagePoints -= 5;

				// Knocked sideways, and if it was on the ground it goes
				// straight back up: it does not stay down to be stomped. On
				// the way up it also calls back whatever Boos are left,
				// because it is the "risalita" state that switches the
				// throw off.
				angolo = (obj_player.x < x) ? 0 : 180;
				velocita = 30 * UNITA;
				image_speed = 1;

				// From the ground or mid-dive it flees upwards; if it was
				// already rising it keeps rising, otherwise stomping it
				// again was enough to pin it down there.
				if(stato == "aterra" || stato == "picchiata")
					stato = "risalita";
				else if(stato != "risalita")
					stato = "vaga";

				// and it calls back whatever Boos are left anyway
				if(modoBoo != "vicino")
					modoBoo = "vicino";
			}

			if(global.jumpHold)
				obj_player.currentY = -6;
			else
				obj_player.currentY = -3;

			// He is placed on top of the orb, but NEVER inside or above the
			// ceiling: stomping it repeatedly while it rose pushed Mario up
			// a bit at a time and he ended up outside the room. Starting
			// from where he would go, move down until he is clear, and
			// never below where he already was.
			var appoggio = bbox_top;
			with(obj_player) {
				var quota = appoggio;
				while(quota < y && place_meeting(x, quota, obj_ground_group))
					quota += 1;
				y = quota;
			}
		}

		// fireball and hammer 1 point, cross 2 (ev. 299, 300, 301)
		if(fuoco && currentAnim != "damaged") {
			var scoppio = instance_create_layer(fuoco.x, fuoco.y, "Objects", obj_fireball_explosion);
			scoppio.emitter = fuoco.emitter;
			instance_destroy(fuoco);
			audio_play_sound(snd_boss_2_weapon, 1, false);      // inpact_08
			audio_play_sound(snd_boss_3_hit, 1, false);
			currentAnim = "damaged";
			animationTimeout = 0;
			image_index = 0;
			damagePoints -= 1;

			if(stato == "aterra" || stato == "picchiata")
				stato = "risalita";

			if(modoBoo != "vicino")
				modoBoo = "vicino";
		}

		if(martello && currentAnim != "damaged") {
			martello.initial_vertical = -2.5;
			audio_play_sound(snd_boss_2_weapon, 1, false);
			audio_play_sound(snd_boss_3_hit, 1, false);
			currentAnim = "damaged";
			animationTimeout = 0;
			image_index = 0;
			damagePoints -= 1;

			if(stato == "aterra" || stato == "picchiata")
				stato = "risalita";

			if(modoBoo != "vicino")
				modoBoo = "vicino";
		}

		if(croce && currentAnim != "damaged") {
			audio_play_sound(snd_boss_2_weapon, 1, false);
			audio_play_sound(snd_boss_3_hit, 1, false);
			currentAnim = "damaged";
			animationTimeout = 0;
			image_index = 0;
			damagePoints -= 2;

			if(stato == "aterra" || stato == "picchiata")
				stato = "risalita";

			if(modoBoo != "vicino")
				modoBoo = "vicino";
		}

		// Touching it hurts, as with the other two bosses. There is NO
		// contact damage among the orb's own events: in the original the
		// general enemy handling does it, and that does not run here.
		if(place_meeting(x, y + 10, obj_player) && !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
			mario_damage(3);

		if(currentAnim == "damaged") {
			animationTimeout += elapsed;
			sprite_index = spr_boss_3_damaged;

			// Six frames at 25 per second. Once the flashing is over it
			// flees UPWARDS at speed 10 + random(5) (ev. 293).
			if(animationTimeout > 6 / 25) {
				currentAnim = "idle";
				sprite_index = spr_boss_3_idle;
				image_speed = (stato == "picchiata") ? 2 : 1;

				if(stato == "vaga") {
					angolo = 90;
					velocita = (10 + irandom(5)) * UNITA;
				}
			}
		}

		if(damagePoints <= 0) {
			active = false;

			audio_stop_sound(global.bgm_boss_intro);
			audio_stop_sound(global.bgm_boss_loop);
			audio_sound_gain(global.bgm_boss_loop, 0, 0);
			audio_play_sound(snd_boss_3_defeat, 1, false);   // boss_04 in the original

			// It crumbles where it is: nine frames (699-707 of the
			// original's bank, the Kouka_06 animation).
			sprite_index = spr_boss_3_defeat;
			image_index = 0;
			image_speed = 1;

			// They die too (ev. 303), each in its own way: the Boos
			// vanishing in the ring of light, the skeletons collapsing into
			// bones that then fall down.
			with(obj_boss_3_boo) {
				instance_create_layer(x, y, "Objects", obj_piranha_plant_defeated);
				instance_destroy();
			}

			with(obj_dry_bones) {
				if(!defeated) {
					defeated = true;
					ossa = false;
					defeatedYSpeed = 0;
					sprite_index = spr_drybones_defeated;
					image_speed = 0;
					image_xscale = 1;
					audio_play_sound(snd_dry_bones_hit, 1, false);
				}
			}
		}
	} else {
		defeatedTimeout += delta_time / 1000000;

		// once it has crumbled away there is nothing left
		if(sprite_index == spr_boss_3_defeat && image_index >= image_number - 1)
			sprite_index = noone;

		if(defeatedTimeout > 1 && !defeatedMusic) {
			defeatedMusic = true;
			audio_play_sound(global.bgm_boss_defeated, 1, false);
		}

		if(defeatedTimeout > 5.5) {
			audio_sound_gain(global.bgm_boss_loop, 1, 0);
			global.currentStage = 4;
			level_finished(global.currentStage, global.playerWeapon, global.hearts, global.pHealth);
			room_goto(stage_intro);
		}
	}
} else {
	image_speed = 0;
}
