if(global.playerDead || !instance_exists(obj_player)) {
	image_speed = 0;
	exit;
}

// without the orb there is nothing left to follow
if(!instance_exists(obj_boss_3)) {
	instance_destroy();
	exit;
}

var elapsed = delta_time / 1000000;

// Where it should be right now: a point along its own ray, at a distance
// that comes and goes. When the orb is on the ground the ray stretches way
// out, and that is how they get flung away and then called back: it is
// always the same mechanism, only the target changes.
fase += velFase * elapsed;

var distanza;
switch(obj_boss_3.modoBoo) {

	// The attack the orb makes while staying up: they spread out SPINNING,
	// and keep going until they have all left the room, same as in the
	// other attack. The only difference from the dive is that here the
	// direction rotates, so they leave in a spiral instead of straight.
	case "spirale": {
		direzione += velRotazione * elapsed;
		distanzaLancio += velUscita * elapsed;
		distanza = distanzaLancio;
		break;
	}

	// The dive attack: they shoot out STRAIGHT, each along its own
	// direction, until they are outside the room. They are not destroyed,
	// because the orb calls them back as it rises.
	case "fuori": {
		distanzaLancio += velUscita * elapsed;
		distanza = distanzaLancio;
		break;
	}

	// At rest: they close in on it and move away again, always along their
	// own ray.
	default: {
		distanzaLancio = 0;
		distanza = distanzaMax * (1 - cos(fase)) / 2;
		break;
	}
}

var bersaglioX = obj_boss_3.x + lengthdir_x(distanza, direzione);
var bersaglioY = obj_boss_3.y + lengthdir_y(distanza, direzione);

var quanto = point_distance(x, y, bersaglioX, bersaglioY);
if(quanto > 0.5) {
	var verso = point_direction(x, y, bersaglioX, bersaglioY);
	var passo = min(quanto, velInseguimento * elapsed);
	var prima = x;
	x += lengthdir_x(passo, verso);
	y += lengthdir_y(passo, verso);

	if(abs(x - prima) > 0.05)
		versoUltimo = sign(x - prima);
}

image_index = (versoUltimo < 0) ? 1 : 0;

// The three weapons destroy it (ev. 321, 322, 323). You cannot jump on its
// head: there is no stomp among its events.
var fuoco = instance_place(x, y, obj_fireball);
var martello = instance_place(x, y, obj_hammer_player);
var croce = instance_place(x, y, obj_cross);

if(fuoco || martello || croce) {
	if(fuoco) {
		var scoppio = instance_create_layer(fuoco.x, fuoco.y, "Objects", obj_fireball_explosion);
		scoppio.emitter = fuoco.emitter;
		instance_destroy(fuoco);
	}

	if(martello)
		instance_destroy(martello);

	audio_play_sound(snd_boss_3_boo_dead, 1, false);
	instance_create_layer(x, y, "Objects", obj_piranha_plant_defeated);
	instance_destroy();
	exit;
}

if(place_meeting(x, y, obj_player) && !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash)
	mario_damage(3);
