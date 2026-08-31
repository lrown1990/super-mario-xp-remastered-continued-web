if(!global.playerDead && instance_exists(obj_player)) {
	if(active) {
		var elapsed = delta_time / 1000000;

		if(!sinking) {
			// insegue Mario di 1 pixel ogni 100 ms, fra le X 60 e 900 (ev. 357, 358)
			chaseTimer += elapsed;
			while(chaseTimer >= 0.1) {
				chaseTimer -= 0.1;

				if(x > obj_player.x && x > 60)
					x -= 1;
				else if(x < obj_player.x && x < 900)
					x += 1;
			}

			// sale finche' non arriva a quota 160 (ev. 359)
			if(y > riseLimit) {
				y -= 1;

				// finche' sta risalendo il cronometro del tuffo non corre:
				// deve contare da quando e' arrivata sul ponte, se no si
				// tuffa mentre e' ancora sotto
				slamTimer = 0;
			} else {
				// arrivata in quota dondola di 13 pixel a 12 pixel al secondo:
				// e' il percorso registrato nell'originale, un tratto in ciclo
				// con inversione alla fine
				bobTime += elapsed;
				y = riseLimit - abs(((bobTime * 12) mod 26) - 13);

				// Si lascia cadere: nell'originale (ev. 382) e' un secco "ogni
				// 3000 ms", qui l'attesa e' sorteggiata a ogni giro in un
				// intorno di quel valore, cosi' non si prende il tempo.
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
			// cade accelerando (ev. 360). Colpita scappa: scende piu' in fretta
			// e scarta di lato, a destra o a sinistra a caso
			fallSpeed += 0.5;
			y += fallSpeed / 2;

			if(fleeDir != 0) {
				x = clamp(x + fleeDir * 1.5, 60, 900);
			}

			// toccando terra lancia quattro spore (ev. 383)
			if(!slammed && place_meeting(x, y + 1, obj_ground_group)) {
				slammed = true;
				audio_play_sound(snd_boss_2_land, 1, false);

				// Quattro spore, e il ventaglio NON e' inventato: la maschera
				// delle direzioni nell'evento 383 e' 0x1ff0, cioe' le direzioni
				// da 4 a 12 delle 32 di Clickteam, da 45 a 135 gradi a passi di
				// 11,25. Il gioco ne sorteggia una per ogni spora.
				// La spinta base e' "15 + casuale(10)" in unita' Clickteam. Il
				// cambio di 6,25 pixel al secondo per unita' e' documentato per
				// i PERCORSI registrati, non per un oggetto lanciato: a quel
				// valore l'apice della parabola veniva a 17 pixel e la pianta
				// se le buttava addosso. SPINTA e' il moltiplicatore tarato a
				// occhio, ed e' l'unico numero da girare se l'arco non convince
				// (con 1,45 e gravita' 0,08 l'apice sta fra i 32 e gli 88 pixel,
				// ma la parabola e' piu' lenta sia a salire sia a scendere).
				var SPINTA = 1.45;

				for(var i = 0; i < 4; i++) {
					var spore = instance_create_layer(x, y, "Objects", obj_boss_2_spore);
					spore.direction = 45 + irandom(8) * 11.25;
					spore.speed = (15 + irandom(10)) * 6.25 / 60 * SPINTA;
				}
			}

			// sotto quota 260 riemerge a una X casuale (ev. 361)
			if(y > sinkLimit) {
				x = 40 + irandom(880);
				y = sinkLimit;
				fallSpeed = 0;
				sinking = false;
				fleeDir = 0;
				image_index = 0;
			}
		}

		// i tentacoli spuntano piu' in fretta man mano che incassa danno (ev. 370, 371, 372)
		var taken = 18 - damagePoints;
		var tentacleDelay = 1.8;
		if(taken >= 12)
			tentacleDelay = 0.6;
		else if(taken >= 6)
			tentacleDelay = 1.1;

		// spuntano da terra a una X casuale DENTRO L'INQUADRATURA, non dalla
		// pianta: nell'originale l'ev. 15 sposta di continuo il segnaposto a
		// "bordo sinistro dello schermo + casuale(320)"
		tentacleTimer += elapsed;
		if(tentacleTimer >= tentacleDelay) {
			tentacleTimer = 0;

			// Nasce gia' alla quota d'attesa dell'originale: cima a y=230,
			// misurata sul video. L'origine dello sprite sta 14 pixel sotto
			// la cima, quindi l'oggetto va messo a 244.
			// La X e' sorteggiata dentro l'inquadratura (ev. 15), ma limitata
			// alla zona del ponte: gli estremi 60 e 900 sono gli stessi entro
			// cui l'originale tiene la pianta (ev. 357 e 358), cioe' il tratto
			// giocabile fra l'entrata e l'uscita.
			var viewX = camera_get_view_x(view_camera[0]);
			var x1 = max(viewX, 60);
			var x2 = min(viewX + 320, 900);

			if(x2 > x1)
				instance_create_layer(x1 + irandom(x2 - x1), 244, "Objects", obj_boss_2_tentacle);
		}

		// Le armi contano solo se prendono il FIORE, non le foglie. Il riquadro
		// e' misurato sullo sprite: nell'originale i pixel rossi del fiore
		// stanno in x 33..57 e y 4..13 di un disegno 90x120 con l'origine a
		// (44,24), cioe' qui sotto, con qualche pixel di tolleranza.
		var tx1 = x - 13, ty1 = y - 22, tx2 = x + 15, ty2 = y - 8;

		var fireTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_fireball, false, true);
		var hammerTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_hammer_player, false, true);
		var crossTouched = collision_rectangle(tx1, ty1, tx2, ty2, obj_cross, false, true);

		// Pestata: 2 punti (ev. 363). Vale solo sul fiore, non sulle foglie,
		// che sono fronde e non ci si sta in piedi. Stesso riquadro delle armi.
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

		// palla di fuoco e martello: 1 punto. croce: 2 (ev. 364, 365, 366)
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

			// l'uscita del quadro resta disattivata anche dopo: battuto il
			// boss si passa allo stadio dopo da soli, e riattivarla faceva
			// solo ricomparire il suo rettangolo verde in fondo a destra
			audio_stop_sound(global.bgm_boss_intro);
			audio_stop_sound(global.bgm_boss_loop);
			audio_sound_gain(global.bgm_boss_loop, 0, 0);
			audio_play_sound(snd_impact_generic, 1, false);

			image_index = 0;
			sprite_index = spr_boss_2_defeat;

			// i tentacoli non spariscono: muoiono tutti insieme come se fossero
			// stati colpiti nello stesso istante, ognuno col suo effetto, e lo
			// stelo senza testa se ne va verso il basso
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
