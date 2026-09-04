if(global.playerDead) {
	image_speed = 0;
	return;
}

var passo = delta_time / 1000000;

// ---- he is down: the room stops and the stage ends -----------------------
if(stato == "morto") {
	morteTimeout += passo;

	if(!ripulito) {
		// Everything he left in the air goes out with him (ev. 280 destroys the
		// anchor and the dummy as well).
		// NO global.bossFermo here, unlike the dinosaurs: that freeze exists
		// because their arena is a set of lifts over lava, where the player
		// kept climbing through the victory music and could die after having
		// already won. This arena is a flat floor with nothing to fall into,
		// so freezing him would only look wrong.
		ripulito = true;
		with(obj_boss_6_magic) instance_destroy();
		with(obj_boss_6_block) instance_destroy();
		with(obj_boss_6_thwomp) instance_destroy();

		// The arena's piranha plant goes down with him. It is the one thing
		// left that could still kill the player during the victory music, now
		// that he is free to walk about. Killed the same way the player's
		// weapons kill it, so it flips over and drops instead of vanishing.
		if(instance_exists(obj_piranha_plant))
			audio_play_sound(snd_enemy_defeat, 1, false);
		with(obj_piranha_plant) {
			if(!dead) {
				dead = true;
				var verso = reverse ? -1 : 1;
				instance_create_layer(x, y - 8 * verso, "Objects", obj_piranha_plant_defeated);
				instance_destroy();
			}
		}

		// Stopping the stage music is not enough: obj_stage_manager's Step
		// starts stage_bgm_loop again the moment it hears it is not playing, so
		// the level track comes back up underneath. Its gain goes to zero too,
		// and back to one before leaving the room. Same as obj_boss_4 and _5.
		audio_stop_sound(global.bgm_boss_intro);
		audio_stop_sound(global.bgm_boss_loop);
		audio_sound_gain(global.bgm_boss_loop, 0, 0);
		audio_play_sound(snd_kamek_defeat, 1, false);   // "boss_08", ev. 280
	}

	// The death animation is the object ev. 280 shoots from the anchor,
	// Kouka_06: the flattening is its animation 0 and the dissolve its
	// animation 4. Playing them back to back as one sprite made the whole
	// thing last 0.77 s and read as "he falls over and vanishes": on the video
	// the pause lying there and the slow dissolve are most of what you see.
	if(sprite_index == spr_boss_6_death) {
		if(image_index >= image_number - 1) {
			image_speed = 0;                       // flat, and it stays there
			image_index = image_number - 1;
		}
		if(morteTimeout > DURATA_SCHIACCIATA + PAUSA_MORTE) {
			sprite_index = spr_boss_6_death_fade;
			image_index = 0;
			image_speed = 1;
		}
	} else if(sprite_index == spr_boss_6_death_fade && image_index >= image_number - 1) {
		image_speed = 0;
		visible = false;
	}

	if(morteTimeout > 1 && !musicaMorte) {
		musicaMorte = true;
		audio_play_sound(global.bgm_boss_defeated, 1, false);
	}
	// ev. 9: five seconds after he is gone the stage is over
	if(morteTimeout > 5.5) {
		audio_sound_gain(global.bgm_boss_loop, 1, 0);
		global.currentStage = 7;
		level_finished(global.currentStage, global.playerWeapon, global.hearts, global.pHealth);
		room_goto(stage_intro);   // obj_stage_intro_manager takes it to stage_7_1
	}
	return;
}

// ---- sideways: he slides to his anchor, and only then can he act ---------
var arrivato = (abs(ancoraX - x) <= ARRIVATO);

if(!arrivato) {
	var d = sign(ancoraX - x) * VELOCITA_SCATTO * passo;
	if(abs(d) >= abs(ancoraX - x)) x = ancoraX;
	else x += d;

	// ev. 272: the after-image, and it is the negated condition that says it —
	// the trail belongs to the travelling, not to the standing still.
	attesaScia += passo;
	if(attesaScia >= PASSO_SCIA) {
		attesaScia = 0;
		var s = instance_create_layer(x, y, "Objects", obj_boss_6_trail);
		s.image_xscale = image_xscale;
	}
} else {
	attesaScia = PASSO_SCIA;
}

// ev. 273 and 274: standing still, or flinching, he turns to face the player.
if((stato == "fermo" || lampeggio > 0) && instance_exists(obj_player)) {
	var v = sign(obj_player.x - x);
	if(v != 0) direzione = v;
}
image_xscale = direzione;

// ---- what he does -------------------------------------------------------
switch(stato) {

case "scatto":
	if(arrivato) {
		stato = "fermo";
		if(lampeggio <= 0) {
			sprite_index = spr_boss_6;
			image_index = 0;
		}
	}
	break;

case "fermo":
	if(!arrivato) break;

	attesaSposta += passo;
	attesaMagia += passo;
	attesaEvoca += passo;
	attesaThwomp += passo;

	// ev. 282: one chance in four every 500 ms, he picks another spot
	if(attesaSposta >= ATTESA_SPOSTA) {
		attesaSposta = 0;
		if(irandom(PROBABILITA - 1) == 0) {
			ancoraX = ANCORA_MIN + irandom(ANCORA_MAX - ANCORA_MIN);
			audio_play_sound(snd_kamek_voice, 1, false);   // "boss_07"
			stato = "scatto";
			break;
		}
	}

	// ev. 284/285: one chance in four every 300 ms, the spell
	if(attesaMagia >= ATTESA_MAGIA) {
		attesaMagia = 0;
		if(irandom(PROBABILITA - 1) == 0) {
			stato = "magia";
			sprite_index = spr_boss_6_magic;
			image_index = 0;
			image_speed = 1;
			audio_play_sound(snd_kamek_magic, 1, false);   // "inpact_19"
			break;
		}
	}

	// ev. 289: one chance in four every second, and only once he is hurt
	// enough. This is the attack the guide means by "he gets more serious".
	if(vita <= VITA_BLOCCHI && attesaEvoca >= ATTESA_EVOCA) {
		attesaEvoca = 0;
		if(irandom(PROBABILITA - 1) == 0) {
			stato = "evoca";
			sprite_index = spr_boss_6_summon;
			image_index = 0;
			image_speed = 1;
			tempoEvoca = 0;
			attesaBlocco = 0;
			audio_play_sound(snd_kamek_magic, 1, false);   // "inpact_19"
			break;
		}
	}

	// ev. 295: one chance in four every second, and only while the last Thwomp
	// is back home — in the original the condition is literally "Enemy_23's
	// movement has stopped".
	if(attesaThwomp >= ATTESA_THWOMP && !instance_exists(obj_boss_6_thwomp)) {
		attesaThwomp = 0;
		if(irandom(PROBABILITA - 1) == 0) {
			stato = "thwomp";
			sprite_index = spr_boss_6_thwomp_cast;
			image_index = 0;
			image_speed = 1;
			audio_play_sound(snd_kamek_magic, 1, false);   // "inpact_19"
			break;
		}
	}
	break;

case "magia":
	// ev. 286/287: the bolt leaves at the END of the animation, and there are
	// two of them, at different speeds, once he is below the threshold.
	if(image_index >= image_number - 1) {
		audio_play_sound(snd_kamek_voice, 1, false);   // "boss_07"
		audio_play_sound(snd_boss_4_roar, 1, false);   // "inpact_17"
		var p1 = instance_create_layer(x + 14 * direzione, y - 20, "Objects", obj_boss_6_magic);
		p1.vx = VELOCITA_PALLA * direzione;
		if(vita <= VITA_DUE_PALLE) {
			var p2 = instance_create_layer(x + 14 * direzione, y - 20, "Objects", obj_boss_6_magic);
			p2.vx = VELOCITA_PALLA_2 * direzione;
		}
		stato = "fermo";
		sprite_index = spr_boss_6;
		image_index = 0;
	}
	break;

case "evoca":
	// ev. 291/292: while the animation runs, a block every 150 ms (100 ms when
	// angry), each one dropped where the invisible dummy happens to be.
	tempoEvoca += passo;
	attesaBlocco += passo;
	var cadenza = (vita <= VITA_BLOCCHI_FITTI) ? PASSO_BLOCCHI_FITTI : PASSO_BLOCCHI;
	if(attesaBlocco >= cadenza) {
		attesaBlocco = 0;
		var bx = BLOCCO_X_MIN + irandom(BLOCCO_X_MAX - BLOCCO_X_MIN);
		var by = BLOCCO_Y_MIN + irandom(BLOCCO_Y_MAX - BLOCCO_Y_MIN);
		instance_create_layer(bx, by, "Objects", obj_boss_6_block);
		audio_play_sound(snd_block_hit, 1, false);      // "inpact_04"
	}
	if(tempoEvoca >= DURATA_EVOCA) {
		stato = "fermo";
		sprite_index = spr_boss_6;
		image_index = 0;
	}
	break;

case "thwomp":
	// ev. 296: at the END of the animation the Thwomp is moved onto the
	// player's x and dropped.
	if(image_index >= image_number - 1) {
		audio_play_sound(snd_kamek_1, 1, false);        // "boss_03"
		var tx = instance_exists(obj_player) ? obj_player.x : x;
		instance_create_layer(tx, -32, "Objects", obj_boss_6_thwomp);
		stato = "fermo";
		sprite_index = spr_boss_6;
		image_index = 0;
	}
	break;
}

// ---- being hit ----------------------------------------------------------
if(graziaDanno > 0) graziaDanno -= passo;

if(lampeggio > 0) {
	lampeggio -= passo;
	if(lampeggio <= 0 && stato == "fermo") {
		sprite_index = spr_boss_6;
		image_index = 0;
	}
}

// Every hit needs him STILL, on his anchor (ev. 276-279 all carry that
// condition): while he is zipping across the room he cannot be touched, and
// that is the rule that makes the fight what it is.
var danno = 0;

if(arrivato && graziaDanno <= 0 && stato != "morto") {
	var fuoco = instance_place(x, y, obj_fireball);
	if(fuoco != noone) { instance_destroy(fuoco); danno = 1; }   // ev. 277

	var martello = instance_place(x, y, obj_hammer_player);
	if(danno == 0 && martello != noone) { instance_destroy(martello); danno = 1; }   // ev. 278

	var croce = instance_place(x, y, obj_cross);
	if(danno == 0 && croce != noone) danno = 2;                  // ev. 279

	// ev. 276: the stomp. The original asks for the player NOT to be in the
	// jump animation and for Kamek's y minus 8 to be at or below the player's,
	// which together mean "coming down on top of him".
	if(danno == 0 && instance_exists(obj_player) && place_meeting(x, y, obj_player)) {
		var pg = obj_player;
		if(pg.currentY > 0 && y - 8 >= pg.y) {
			danno = 2;
			pg.currentY = -4;               // he bounces off, as on any enemy
			audio_play_sound(snd_boss_2_stomp, 1, false);   // "inpact_03"
		}
	}
}

if(danno > 0) {
	vita -= danno;
	audio_play_sound(snd_boss_2_weapon, 1, false);   // "inpact_08"
	audio_play_sound(snd_kamek_voice, 1, false);     // "boss_07"
	sprite_index = spr_boss_6_hit;
	image_index = 0;
	image_speed = 1;
	lampeggio = LAMPEGGIO;
	graziaDanno = GRAZIA_DANNO;
	// and he does not stand there: the anchor jumps at once (ev. 276-279)
	ancoraX = ANCORA_MIN + irandom(ANCORA_MAX - ANCORA_MIN);
	stato = "scatto";
}

// ev. 280: in the original the death is an event of its OWN, not a branch of
// the damage: the counter is watched every step and the moment it passes the
// threshold he is gone. Written as a branch of the damage it never fires if
// the counter is lowered from anywhere else, which is exactly what a test
// build that drains his health showed.
if(vita <= 0 && stato != "morto") {
	stato = "morto";
	sprite_index = spr_boss_6_death;
	image_index = 0;
	image_speed = 1;
	morteTimeout = 0;
}

// ---- he hurts on contact, but only while he is still ---------------------
// ev. 25: three hearts, and the same "on his anchor" condition as the damage.
if(arrivato && stato != "morto" && graziaDanno <= 0 &&
   instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(3);
