if(!global.playerDead && instance_exists(obj_player)) {
	if(active) {
		var elapsed = delta_time / 1000000;

		// ---- MOVEMENT
		// ------------------------------------------------------
		switch(stato) {

			// ---- ACQUA (water): hidden under the surface, lining Mario up
			// ------------------------------------------------------
			// In the footage it does not come up wherever it likes: it surfaces
			// near the player, so while it is down there it slides towards his
			// column and then goes up almost straight (43:49 onwards).
			case "acqua": {
				statoTimer += elapsed;

				// The bottom half of the path. Buoyancy pushes it up, so what it
				// draws down here is a ∪ - the same curve as the arch in the air,
				// turned over. It comes back out on its own, no timer needed.
				vy -= SPINTA_ACQUA * elapsed;

				// and it keeps sliding towards the spot it means to surface from
				var voluto = sign(puntoLancio - x) * VELOCITA_ARCO;
				if(abs(puntoLancio - x) < 24)
					voluto = vx;
				vx += clamp(voluto - vx, -200 * elapsed, 200 * elapsed);
				break;
			}

			// ---- SALTO (leap): straight up out of the water. High up, still
			// rising, it stops and opens its jaws (ev. 182-183, y < 90).
			// ------------------------------------------------------
			case "salto": {
				vy += GRAVITA * elapsed;
				// only the "sputo" stops at the top: the long arc sails
				// straight over and comes down the other side
				if(prossimoAttacco == "sputo" && y < 96 && vy < 0) {
					stato = "morso";
					vx = 0;
					vy = 0;
					verso = (obj_player.x >= x) ? 1 : -1;
					sprite_index = spr_boss_4_bite;
					image_index = 0;
					image_speed = 1;
					sputato = false;
					attesaBocca = 0;
					audio_play_sound(snd_boss_4_leap, 1, false);     // inpact_18, il suo
				}
				break;
			}

			// ---- MORSO (bite): jaws open, then THREE fireballs at Mario
			// (ev. 184-185), then it leans over and comes down.
			// ------------------------------------------------------
			case "morso": {
				// The jaws open, and then it HOLDS, hanging there with its mouth
				// burning, for a second and a bit. Only then do the three
				// fireballs leave (ev. 184-185) and only then does it drop. The
				// hold is the warning: without it the shot came out of nowhere.
				if(image_index >= image_number - 1) {
					image_index = image_number - 1;
					image_speed = 0;
					if(attesaBocca == 0)
						xBocca = x;
					attesaBocca += elapsed;

					// it shakes while it holds: a pixel either way, every
					// frame. Small, but it reads as the thing straining
					// before it lets go.
					if(!sputato)
						x = xBocca + irandom_range(-1, 1);
					else
						x = xBocca;

					if(!sputato && attesaBocca >= SECONDI_BOCCA) {
						sputato = true;
						audio_play_sound(snd_boss_4_roar, 1, false);     // inpact_17, il ruggito
						var mira = point_direction(x, y, obj_player.x, obj_player.y - 8);
						for(var k = -1; k <= 1; k++) {
							var f = instance_create_layer(x + verso * 12, y, "Objects", obj_boss_4_fireball);
							f.vx = lengthdir_x(210, mira + k * 14);
							f.vy = lengthdir_y(210, mira + k * 14);
						}
					}

					// a breath after the shot, then down it goes
					if(sputato && attesaBocca >= SECONDI_BOCCA + 0.35) {
						stato = "arco";
						vx = verso * VELOCITA_ARCO * 0.6;
						vy = 0;
						sprite_index = spr_boss_4_idle;
						image_speed = 0;
					}
				}
				break;
			}

			// ---- ARCO (arc): it comes down leaning across, and while it falls
			// it keeps steering towards Mario. That steering is what draws the
			// long S the body makes behind it, instead of a flat parabola.
			// ------------------------------------------------------
			case "arco": {
				vy += GRAVITA * elapsed;
				var voluto = sign(obj_player.x - x) * VELOCITA_ARCO;
				vx += clamp(voluto - vx, -260 * elapsed, 260 * elapsed);
				break;
			}

			// ---- RIMBALZO (bounce): the last phase. The body is gone and the
			// head alone bounces around the walkway going for the player, as it
			// does at the end of the footage (44:30 onwards).
			// ------------------------------------------------------
			case "rimbalzo": {
				vy += GRAVITA * elapsed;
				// It aims at a point PAST Mario, not at Mario: it runs by
				// him, turns round out there and comes back. Sitting on top
				// of him is what it did before, and there was no dodging it.
				var meta = clamp(obj_player.x + latoRimbalzo * SCARTO_RIMBALZO, 24, room_width - 24);
				if(abs(meta - x) < 24)
					latoRimbalzo = -latoRimbalzo;
				var voluto2 = sign(meta - x) * VELOCITA_RIMBALZO;
				vx += clamp(voluto2 - vx, -320 * elapsed, 320 * elapsed);
				break;
			}
		}

		if(stato != "morso") {
			x += vx * elapsed;
			y += vy * elapsed;
		}

		// The walls send it back in (ev. 163-164).
		// Turned back before its sprite can touch the new side walls: those
		// are obj_ground too, and if the head overlapped one the walkway
		// check below would read it as a landing and bounce it for nothing.
		if(x < 22) { x = 22; vx = abs(vx); }
		if(x > room_width - 28) { x = room_width - 28; vx = -abs(vx); }

		// It is allowed off the top of the screen and comes back (ev. 176).
		if(y < -30) {
			y = -20;
			if(vy < 0) vy = 0;
		}

		// Bouncing on the walkway (ev. 189-190). It is NOT solid every time,
		// or the serpent would never get back to the water and the whole
		// cycle would die on the bridge - which is what happened at the
		// first try. It bounces when it comes in FLAT, skimming along the
		// walkway, and goes straight through when it drops steeply, which
		// is the dive back into the water you see in the footage. The head
		// on its own always bounces: that is how it skips along the bridge
		// at 44:30.
		// AND IT ONLY BOUNCES ONCE OR TWICE. Without a count it kept
		// bouncing on the walkway for ever and never went back down: the
		// whole cycle died up there. After its allowance is used up the
		// walkway stops stopping it and it drops through into the water.
		// The lone head is the exception: that one climbs onto the bridge
		// and stays there bouncing, which is what it does at 44:30.
		if(vy > 0 && y < 200 && place_meeting(x, y + 2, obj_ground_group)) {
			if(soloTesta) {
				vy = -VELOCITA_SALTO * 0.42;
				audio_play_sound(snd_impact_generic, 1, false);      // inpact_04
			} else if(abs(vx) > abs(vy) && rimbalziPonte < rimbalziMax) {
				rimbalziPonte++;
				vy = -VELOCITA_SALTO * 0.55;
				audio_play_sound(snd_impact_generic, 1, false);
			}
		}

		// Crossing the water line, either way: the plume and the sound. In the
		// original this is the "Active 1" object, ten frames (ev. 177-178).
		var sottAcqua = (y > QUOTA_ACQUA);
		if(sottAcqua != eraSottAcqua) {
			var sp = instance_create_layer(x, QUOTA_ACQUA + 8, "Objects", obj_splash);
			audio_play_sound(snd_boss_4_splash, 1, false);           // inpact_11

			if(sottAcqua && !soloTesta) {
				// GOING IN. It keeps its sideways speed - that is what makes the
				// curve down there wide instead of a dead drop - but it always
				// goes in with a real push, or it would bob straight back out.
				stato = "acqua";
				statoTimer = 0;
				vy = max(vy, DISCESA_MINIMA);
				vx *= 0.92;   // keeps its run: that is what makes the ∪ wide
				sprite_index = spr_boss_4_idle;
				image_speed = 0;

				// what it will do next, and where it will come up from
				prossimoAttacco = (irandom(2) == 0) ? "sputo" : "tuffo";
				if(prossimoAttacco == "sputo") {
					puntoLancio = clamp(obj_player.x + choose(-40, 40), 40, room_width - 40);
				} else {
					var lato = (obj_player.x > room_width / 2) ? -1 : 1;
					puntoLancio = clamp(obj_player.x + lato * DISTANZA_LANCIO, 40, room_width - 40);
				}
			} else if(sottAcqua && soloTesta) {
				// the head alone does not stop to rest: it comes straight back
				vy = -VELOCITA_SALTO * 0.9;
			} else if(!sottAcqua && stato == "acqua") {
				// COMING OUT: this is the leap, and the ∪ hands straight over to
				// the ∩ without a pause in between.
				stato = "salto";
				image_index = 0;
				rimbalziPonte = 0;
				rimbalziMax = choose(1, 2);
				if(prossimoAttacco == "sputo") {
					vx = sign(obj_player.x - x) * (10 + irandom(30));
					vy = -VELOCITA_SALTO;
				} else {
					// THE WIDE ARCH: the climb is fixed, so the flight time is
					// fixed, and the sideways speed is just the ground to cover
					// divided by it. Aiming PAST him keeps the arch broad instead
					// of folding into a steep hop.
					vy = -sqrt(2 * GRAVITA * max(60, QUOTA_ACQUA - QUOTA_ARCO));
					var volo = 2 * abs(vy) / GRAVITA;
					var arrivo = clamp(obj_player.x + sign(obj_player.x - x) * 90, 24, room_width - 24);
					vx = clamp((arrivo - x) / volo, -340, 340);
				}
			}
		}
		eraSottAcqua = sottAcqua;

		// it never sinks further than this, as in the original (ev. 175)
		if(y > QUOTA_FONDO) {
			y = QUOTA_FONDO;
			if(vy > 0) vy = 0;
		}

		// which way it looks: along the way it is going
		if(stato != "morso" && abs(vx) > 4)
			verso = (vx < 0) ? -1 : 1;
		image_xscale = verso;

		// ---- THE TRAIL THE BODY RIDES ON
		// ------------------------------------------------------
		if(!soloTesta && point_distance(x, y, ultimoPunto[0], ultimoPunto[1]) >= PASSO_SCIA) {
			array_insert(scia, 0, [x, y]);
			ultimoPunto = [x, y];
			// four points per link, eight links: nothing older is needed
			if(array_length(scia) > 8 * 4 + 4)
				array_resize(scia, 8 * 4 + 4);
		}
		for(var i = 0; i < array_length(segmenti); i++) {
			var p = (i + 1) * 4;
			if(p < array_length(scia)) {
				segmenti[i].x = scia[p][0];
				segmenti[i].y = scia[p][1];
			}
		}

		// ---- THE HITS
		// ------------------------------------------------------
		// ONLY THE HEAD TAKES DAMAGE. The body is armour: hitting a link
		// does nothing, and it must not do anything even when the links are
		// bunched up around the head and their boxes overlap it. So a weapon
		// counts only if it is inside the head's own core, eighteen pixels
		// from the middle of it.
		var vicino = function(a) {
			return (a != noone && point_distance(a.x, a.y, x, y) < 18) ? a : noone;
		};
		var fuoco = vicino(instance_place(x, y, obj_fireball));
		var martello = vicino(instance_place(x, y, obj_hammer_player));
		var croce = vicino(instance_place(x, y, obj_cross));

		// Stomp: 3 points (ev. 166), only on the head, and only if Mario is
		// coming down on it - the same test the other bosses use.
		if(place_meeting(x, y - obj_player.currentY, obj_player) && !place_meeting(x, y + 10, obj_player) &&
		   obj_player.y < y && abs(obj_player.x - x) < 22) {
			if(!colpito) {
				audio_play_sound(snd_boss_2_stomp, 1, false);        // inpact_03
				audio_play_sound(snd_boss_3_hit, 1, false);          // boss_06
				ferisci(3);
			}
			obj_player.currentY = global.jumpHold ? -6 : -3;
		}

		if(fuoco && !colpito) {
			var scoppio = instance_create_layer(fuoco.x, fuoco.y, "Objects", obj_fireball_explosion);
			scoppio.emitter = fuoco.emitter;
			instance_destroy(fuoco);
			audio_play_sound(snd_boss_2_weapon, 1, false);           // inpact_08
			audio_play_sound(snd_boss_3_hit, 1, false);
			ferisci(1);
		}

		if(martello && !colpito) {
			martello.initial_vertical = -2.5;
			audio_play_sound(snd_boss_2_weapon, 1, false);
			audio_play_sound(snd_boss_3_hit, 1, false);
			ferisci(1);
		}

		if(croce && !colpito) {
			audio_play_sound(snd_boss_2_weapon, 1, false);
			audio_play_sound(snd_boss_3_hit, 1, false);
			ferisci(2);
		}

		// Touching it hurts - but NOT from above, or landing on its head
		// would hurt you at the same moment as it counted as a stomp. Same
		// trick the second boss uses: the mask is tested shifted DOWN, so
		// something resting on top of it falls outside.
		if(place_meeting(x, y + 10, obj_player) && !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
			mario_damage(3);

		// the flash, on the head as well as on every link
		if(colpito) {
			colpitoTimeout += elapsed;
			if(sprite_index != spr_boss_4_damaged) {
				sprite_index = spr_boss_4_damaged;
				image_index = 0;
				image_speed = 1;
			}
			if(colpitoTimeout > 6 / 25) {
				colpito = false;
				sprite_index = (stato == "morso") ? spr_boss_4_bite : spr_boss_4_idle;
				image_speed = (stato == "morso") ? 1 : 0;
			}
		}

		if(damagePoints <= 0) {
			active = false;
			audio_stop_sound(global.bgm_boss_intro);
			audio_stop_sound(global.bgm_boss_loop);
			audio_sound_gain(global.bgm_boss_loop, 0, 0);
			audio_play_sound(snd_boss_3_defeat, 1, false);

			// The whole chain goes down with the head (ev. 173).
			with(obj_boss_4_segment) {
				instance_create_layer(x, y, "Objects", obj_piranha_plant_defeated);
				instance_destroy();
			}

			// The head crumbles away where it is: nine frames, the animation
			// the original calls Kouka_06 (777 and 819-826 of the bank).
			sprite_index = spr_boss_4_defeat;
			image_index = 0;
			image_speed = 1;
			vx = 0;
			vy = 0;
		}
	} else {
		defeatedTimeout += delta_time / 1000000;

		// once it has crumbled away there is nothing left
		if(sprite_index == spr_boss_4_defeat && image_index >= image_number - 1)
			sprite_index = noone;

		if(defeatedTimeout > 1 && !defeatedMusic) {
			defeatedMusic = true;
			audio_play_sound(global.bgm_boss_defeated, 1, false);
		}

		if(defeatedTimeout > 5.5) {
			audio_sound_gain(global.bgm_boss_loop, 1, 0);
			global.currentStage = 5;
			level_finished(global.currentStage, global.playerWeapon, global.hearts, global.pHealth);
			room_goto(stage_intro);
		}
	}
} else {
	image_speed = 0;
}
