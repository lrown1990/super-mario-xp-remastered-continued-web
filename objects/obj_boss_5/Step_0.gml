if(global.playerDead) {
	image_speed = 0;
	return;
}

var passo = delta_time / 1000000;

if(morto) {
	// it falls away and the fight only ends when the last one is gone
	vy += GRAVITA;
	y += vy;
	morteTimeout += passo;

	// the fight is over only when the last of the four is gone
	if(instance_number(obj_boss_5) == 1) {
		// The last one is down: the room stops. The lifts hold where they are,
		// the fireballs still in the air go out, and the player is frozen. He
		// had to keep climbing through the victory music, and could die after
		// having already won.
		if(!global.bossFermo) {
			global.bossFermo = true;
			with(obj_moving_platform) active = false;
			with(obj_boss_4_fireball) instance_destroy();

			// The stage music has to be silenced the way obj_boss_4 does it, and
			// stopping it is NOT enough: obj_stage_manager's Step starts
			// stage_bgm_loop again the moment it hears it is not playing, so the
			// level track came back up underneath the victory jingle. Its gain is
			// taken to zero as well, and put back before leaving the room.
			audio_stop_sound(global.bgm_boss_intro);
			audio_stop_sound(global.bgm_boss_loop);
			audio_sound_gain(global.bgm_boss_loop, 0, 0);
		}

		if(morteTimeout > 1 && !musicaMorte) {
			musicaMorte = true;
			audio_play_sound(global.bgm_boss_defeated, 1, false);
		}
		if(morteTimeout > 5.5) {
			audio_sound_gain(global.bgm_boss_loop, 1, 0);   // rimessa come la trova obj_boss_4
			global.bossFermo = false;
			global.currentStage = 6;
			level_finished(global.currentStage, global.playerWeapon, global.hearts, global.pHealth);
			room_goto(stage_intro);   // obj_stage_intro_manager porta a stage_6_1
		}
		return;
	}

	if(y > room_height + 64 || morteTimeout > 3)
		instance_destroy();
	return;
}

// ---- up and down: it rides a lift, or falls onto one ---------------------
// The only footing in this arena is the lifts: 48 wide, 8 tall, in six columns
// 96 apart, so half of every row is a gap. Getting this wrong sent all four
// into an endless fall, and there were two separate reasons:
//  - the drop has to be SWEPT. Coming down from the top the speed passes 15
//    pixels a step, and one step that size goes straight over an 8 pixel
//    platform: they tunnelled through every lift and never landed again.
//  - a hop has to be aimed at a COLUMN, never between two.
suoloSotto = instance_place(x, y + 2, obj_moving_platform);

if(suoloSotto != noone && vy >= 0) {
	y = suoloSotto.y;                       // ride it down
	vy = 0;
} else {
	vy = min(vy + GRAVITA, VY_MAX);
	var passi = max(1, ceil(abs(vy) / PASSO_CADUTA));
	var d = vy / passi;
	for(var k = 0; k < passi; k++) {
		y += d;
		if(vy > 0) {
			var sotto = instance_place(x, y + 1, obj_moving_platform);
			if(sotto != noone) { y = sotto.y; vy = 0; break; }
		}
	}
}

// ---- sideways: it does not walk, it hops ---------------------------------
// The original moves it 2 pixels a step (ev. 283 and 284) but ONLY while
// "animation 0 is playing", and in Clickteam 0 is Stopped while 7 and 8 are
// Jump and Fall. So that shuffle belongs to the moments it is at rest, not to
// the air, which is why in the real game it reads as hopping and never as
// walking.
if(suoloSotto == noone || vy != 0) {
	// in the air it heads for the column it picked and STOPS there, so it
	// cannot sail on into the next gap
	if(vx == 0 || abs(bersaglioX - x) <= abs(vx)) { x = bersaglioX; vx = 0; }
	else x += vx;
} else {
	// At rest it stays put, on the centre of its column. The original's 2 pixel
	// shuffle is left out on purpose: there it lasts the handful of frames
	// between one hop and the next, while here the dinosaur sits on a lift for
	// one to two seconds, and over that long the same shuffle carries it most
	// of the way to the next column. That drift was still reading as walking,
	// and it was what pushed them over the gaps.
	x = bersaglioX;
}

if(spinta != 0) {
	x += spinta;
	spinta -= sign(spinta) * 0.15;
	if(abs(spinta) < 0.15) spinta = 0;
}

// ev. 267 and 268: the walls put it back inside and turn it round
if(x < MURO_SX)  { x = MURO_SX; direzione = 1;  bersaglioX = COLONNA_PRIMA; vx = 0; spinta = 0; }
if(x > MURO_DX)  { x = MURO_DX; direzione = -1; bersaglioX = COLONNA_PRIMA + (COLONNE - 1) * COLONNA_PASSO; vx = 0; spinta = 0; }

// The plume when it goes into the lava: the same one the cheep cheeps and the
// serpent throw up, but on its own recoloured sprite, spr_splash_lava, rather
// than a tint applied at runtime. A recoloured sprite is a thing you can look
// at in the project; a tint is a thing you have to run the game to see.
if(quotaLava == -1) {
	with(obj_lava) {
		if(other.quotaLava == -1 || y < other.quotaLava)
			other.quotaLava = y;
	}
	if(quotaLava >= 0) eraSottoLava = (y > quotaLava);
}

if(quotaLava >= 0) {
	var sottoLava = (y > quotaLava);
	if(sottoLava && !eraSottoLava) {
		var sp = instance_create_layer(x, quotaLava + 8, "Objects", obj_splash);
		sp.sprite_index = spr_splash_lava;
		sp.image_index = 0;
	}
	eraSottoLava = sottoLava;
}

// ev. 269: the lifts go round and so do the dinosaurs. It has to come back
// over a COLUMN: coming back over a gap it would just fall through again, for
// ever, which is exactly what happened.
if(y > QUOTA_RIENTRO) {
	y = QUOTA_ALTA;
	vy = 0;
	vx = 0;
	x = COLONNA_PRIMA + clamp(round((x - COLONNA_PRIMA) / COLONNA_PASSO), 0, COLONNE - 1) * COLONNA_PASSO;
	bersaglioX = x;
	eraSottoLava = false;
}

image_xscale = direzione;

// ---- the hop (ev. 281) ----------------------------------------------------
// It sits on a lift for a moment and then hops again. The original fires this
// every 500 ms; he watched the real game and counts one to two seconds on a
// platform, so the wait is a range. To be tuned.
if(suoloSotto != noone && vy == 0) {
	vx = 0;
	attesaSalto += passo;

	// Two of them on the same lift look wrong and get in each other's way. When
	// it happens the one with the higher id clears off, one or two columns
	// over, so they spread back out. The id is only a tiebreak: it has to be
	// one of the two and always the same one, or they would both move and stay
	// together.
	var compagni = 0;
	var tocca_a_me = false;
	for(var k = 0; k < instance_number(obj_boss_5); k++) {
		var altro = instance_find(obj_boss_5, k);
		if(altro == id || altro.morto) continue;
		if(altro.suoloSotto != noone && altro.suoloSotto == suoloSotto) {
			compagni += 1;
			if(altro.id < id) tocca_a_me = true;
		}
	}
	var affollato = (compagni > 0 && tocca_a_me);

	// Freshly hit it barely touches down before going again, so it never sits
	// there taking a second hit for free. Same haste when it has to move over.
	var attesaOra = (saltiRabbia > 0 || affollato) ? ATTESA_RABBIA : attesaScelta;
	if(attesaSalto >= attesaOra && (y > SOTTO || saltiRabbia > 0 || affollato)) {
		attesaSalto = 0;
		attesaScelta = random_range(ATTESA_SALTO_MIN, ATTESA_SALTO_MAX);
		if(saltiRabbia > 0) saltiRabbia -= 1;
		vy = FORZA_SALTO;
		y -= 1;

		// Three kinds of hop, the ones he describes: straight up, at the
		// player, or one column away from him. Close by it prefers to back off.
		var col = clamp(round((x - COLONNA_PRIMA) / COLONNA_PASSO), 0, COLONNE - 1);
		var versoGiocatore = 0;
		if(instance_exists(obj_player)) versoGiocatore = sign(obj_player.x - x);
		if(versoGiocatore == 0) versoGiocatore = choose(-1, 1);
		var vicino = instance_exists(obj_player) && abs(obj_player.x - x) < VICINO;
		// Hit, it always makes off; close by it prefers to back off; otherwise
		// it picks one of the three he describes.
		var tipo;
		if(saltiRabbia > 0)   tipo = "via";
		else if(vicino)       tipo = (irandom(2) == 0) ? "su" : "via";
		else                  tipo = choose("su", "verso", "via");

		var dest = col;
		if(tipo == "verso") dest = col + versoGiocatore;
		if(tipo == "via")   dest = col - versoGiocatore;

		// sharing a lift beats everything else: one or two columns over, on the
		// side that has room
		if(affollato) {
			var lato = choose(-1, 1);
			if(col <= 0)               lato = 1;
			if(col >= COLONNE - 1)     lato = -1;
			dest = col + lato * irandom_range(1, 2);
		}

		dest = clamp(dest, 0, COLONNE - 1);
		if(affollato && dest == col) dest = (col > 0) ? col - 1 : col + 1;

		bersaglioX = COLONNA_PRIMA + dest * COLONNA_PASSO;
		vx = sign(bersaglioX - x) * VELOCITA_SALTO;
		if(vx != 0) direzione = sign(vx);
	}
}

// ---- the fireball (ev. 286 and 287) ---------------------------------------
attesaSputo += passo;
if(!sputando && saltiRabbia == 0 && attesaSputo >= ATTESA_SPUTO) {
	attesaSputo = 0;
	// ev. 286 is one chance in five every second. With the player close it
	// spits far more readily, which is what he sees in the real game.
	var quante = PROBABILITA_SPUTO;
	if(instance_exists(obj_player) && abs(obj_player.x - x) < VICINO_SPUTO)
		quante = PROBABILITA_SPUTO_VICINO;
	if(irandom(quante - 1) == 0) {
		sputando = true;
		sprite_index = spr_boss_5_spit;
		image_index = 0;
		image_speed = 1;                // the mouth opens and lights up
		if(instance_exists(obj_player)) {
			direzione = sign(obj_player.x - x);
			if(direzione == 0) direzione = 1;
		}
		audio_play_sound(snd_boss_4_leap, 1, false);   // "inpact_18" in the original
	}
}

if(sputando && sprite_index == spr_boss_5_spit && image_index >= image_number - 1) {
	// ev. 287: the shot leaves at the END of the animation
	sputando = false;
	sprite_index = spr_boss_5;
	image_speed = 1;
	audio_play_sound(snd_boss_4_roar, 1, false);       // "inpact_17" in the original
	var palla = instance_create_layer(x + 10 * direzione, y - 14, "Objects", obj_boss_4_fireball);
	palla.vx = 90 * direzione;
	palla.vy = 0;
}

// ---- being hit ------------------------------------------------------------
if(graziaDanno > 0) graziaDanno -= passo;

if(lampeggio > 0) {
	lampeggio -= passo;
	if(lampeggio <= 0 && !sputando) {
		sprite_index = spr_boss_5;
		image_speed = 1;
	}
}

// A single place for damage, so the four weapons share it. The knockback
// direction is the way the weapon was travelling (ev. 274-278).
var danno = 0, versoDanno = 0;

if(graziaDanno <= 0) {
var fuoco = instance_place(x, y, obj_fireball);
if(fuoco != noone) {
	versoDanno = -sign(fuoco.x - x); instance_destroy(fuoco); danno = 2;
}

var martello = instance_place(x, y, obj_hammer_player);
if(danno == 0 && martello != noone) {
	versoDanno = -sign(martello.x - x); instance_destroy(martello); danno = 2;
}

// ev. 272 of the original kills it outright with the cross. Deliberately NOT
// followed: he played it and found it made the fight too easy, so the cross
// takes the same 2 off as the hammer. This is the one place where the boss
// leaves the 2001 data on purpose.
var croce = instance_place(x, y, obj_cross);
if(danno == 0 && croce != noone) {
	versoDanno = -sign(croce.x - x); danno = 2;
}

// ev. 279: the headbutt from below. In the original Mario_06, the one frame
// detector on his head, hits the LIFT (#43) and something is fired: what it
// fires does not decode, but the user says this is what hurts them. Here, if
// the player bumps the lift this one is standing on, it takes a hit.
if(danno == 0 && suoloSotto != noone && instance_exists(obj_player)) {
	// This used to read place_meeting(suoloSotto.x, suoloSotto.y + 4, obj_player),
	// which is wrong: place_meeting always tests THIS instance's own mask, so it
	// was asking whether the DINOSAUR, moved onto the lift, met the player. It
	// never fired: the dinosaur took nothing and the player took the contact
	// damage, which is exactly what he reported. The boxes are compared by hand
	// now: the player's head, on the way up, touching the underside of the lift
	// this one is standing on.
	var pg = obj_player;
	if(pg.currentY < 0 &&
	   pg.bbox_right >= suoloSotto.bbox_left &&
	   pg.bbox_left  <= suoloSotto.bbox_right &&
	   pg.bbox_top   <= suoloSotto.bbox_bottom + TESTATA_MARGINE &&
	   pg.bbox_top   >= suoloSotto.bbox_top) {
		versoDanno = sign(x - pg.x);
		if(versoDanno == 0) versoDanno = choose(-1, 1);
		danno = 2;
	}
}
}

if(danno > 0) {
	if(versoDanno == 0) versoDanno = -direzione;
	vita -= danno;
	audio_play_sound(snd_boss_2_hit, 1, false);
	sprite_index = spr_boss_5_hit;
	if(vita <= 0) {
		morto = true;
		vy = -3;
		image_speed = 1;
		audio_play_sound(snd_enemy_defeat, 1, false);
	} else {
		image_speed = 1;
		lampeggio = 0.5;
		spinta = FORZA_SPINTA * versoDanno;
		graziaDanno = GRAZIA_DANNO;
		// it makes off instead of standing there like a stockfish
		saltiRabbia = irandom_range(SALTI_RABBIA_MIN, SALTI_RABBIA_MAX);
		attesaSalto = ATTESA_RABBIA;   // the first one leaves straight away
		sputando = false;
	}
}

// ---- it hurts on contact, and cannot be stomped ---------------------------
if(graziaDanno <= 0 &&
   instance_exists(obj_player) && place_meeting(x, y, obj_player) &&
   !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(3);
