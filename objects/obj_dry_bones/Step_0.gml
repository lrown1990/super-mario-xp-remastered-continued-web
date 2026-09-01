onCamera =  (x - sprite_width - 32) < (camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0])) &&
			(x + sprite_width + 32) > camera_get_view_x(view_camera[0]) &&
			(y - sprite_height - 92) < (camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0])) &&
			(y + sprite_height + 92 > camera_get_view_y(view_camera[0]));

// In the boss arena the two skeletons are parked outside the walls and do
// not move: it is the orb that frees them after 20 seconds (ev. 308, which
// switches on the "characters on the ground" group). Outside the arena the
// property stays at 0 and nothing changes.
if(dormiente) {
	visible = false;
	image_speed = 0;
	exit;
}

visible = true;

// Waking up has to restart the animation too: while asleep it was stopped
// and nothing switched it back on, so the two in the arena walked with a
// frozen sprite until they were knocked apart and got back up - only there
// did the bones branch put image_speed back to 1.
if(!ossa && !defeated && image_speed == 0)
	image_speed = 1;

var elapsed = delta_time / 1000000;

if(global.playerDead)
	image_speed = 0;

// ---- the pile of bones
// -----------------------------------------------------
if(ossa && !defeated) {
	ossaTempo += elapsed;

	if(ossaTempo < 3) {
		// still, and quiet
		sprite_index = spr_drybones_defeated;
		image_speed = 0;
		image_xscale = 1;
	} else if(ossaTempo < 5) {
		// rattling. The two drawings alternate, and on top of that the pile
		// shifts by a pixel: in the original the pile's three frames are
		// the same drawing with the hotspot moved, so that is exactly the
		// shake.
		sprite_index = spr_dry_bones_fall;
		image_xscale = 1;

		// Slowly. In the original the reassembling is a nine frame
		// animation at speed 20, that is five per second: the port's sprite
		// has two frames and runs at 30, so it has to be slowed to a sixth.
		// It used to run at 30 and looked like a blender.
		image_speed = 5 / 30;

		ossaTremolio += elapsed;
		if(ossaTremolio >= 0.2) {
			ossaTremolio = 0;
			x = xFermo + irandom_range(-1, 1);
		}
	} else {
		// back on its feet
		ossa = false;
		x = xFermo;
		sprite_index = spr_dry_bones;
		image_speed = 1;
	}
}

// ---- walking
// ---------------------------------------------------------------
if(!ossa && !defeated && !global.playerDead && onCamera) {
	currentX = entitySpeed * entityDirection;
	x += currentX;
}

if(entrando)
	entityDirection = (x < room_width / 2) ? 1 : -1;

if(!entrando && !onCamera && instance_exists(obj_player) && !ossa && !defeated) {
	if(x < obj_player.x)
		entityDirection = 1;
	else if(x > obj_player.x)
		entityDirection = -1;
}

if(entrando && x > 0 && x < room_width - sprite_width)
	entrando = false;

if(!ossa && !defeated) {
	// It turns around ONLY at walls. At the edge of a platform it walks
	// straight off and falls: in the video you can see it step down off the
	// ledge in the arena, and in the levels it drops off platforms. It
	// keeps going until it finds a wall.
	if(!entrando && place_meeting(x + round(currentX), y, obj_ground_group))
		entityDirection = -entityDirection;

	image_xscale = entityDirection;
}

// ---- gravity
// ---------------------------------------------------------------
if(onCamera && !global.playerDead && !defeated) {
	currentY += 0.3;

	if(!place_meeting(x, y + round(currentY), obj_ground_group)) {
		y += round(currentY);
	} else {
		while(!place_meeting(x, y + sign(currentY), obj_ground_group))
			y += sign(currentY);

		currentY = 0;
	}

	if(!ossa)
		xFermo = x;
}

// ---- killed
// ----------------------------------------------------------------
if(defeated && !global.playerDead) {
	// Reduced to bones it falls straight down. The little hop upwards
	// belongs to the koopa: here the pile just slumps.
	y += defeatedYSpeed;
	defeatedYSpeed += 0.3;

	if(y > room_height + sprite_height)
		instance_destroy();

	exit;
}

// ---- weapons and stomp
// -----------------------------------------------------
if(instance_exists(obj_player)) {
	var martello = instance_place(x, y, obj_hammer_player);
	var fuoco = instance_place(x, y, obj_fireball);
	var croce = instance_place(x, y, obj_cross);

	// The fireball does nothing to it: it just fizzles out (ev. 211).
	if(fuoco) {
		var scoppio = instance_create_layer(fuoco.x, fuoco.y, "Objects", obj_fireball_explosion);
		scoppio.emitter = fuoco.emitter;
		instance_destroy(fuoco);
		audio_play_sound(snd_fireball_impact, 1, false);
	}

	// The hammer knocks it apart but does not kill it (ev. 212).
	if(martello && !ossa) {
		martello.initial_vertical = -2.5;
		ossa = true;
		ossaTempo = 0;
		xFermo = x;
		audio_play_sound(snd_dry_bones_hit, 1, false);
	}

	// Only the cross kills it (ev. 213).
	if(croce) {
		defeated = true;
		ossa = false;
		audio_play_sound(snd_enemy_defeat, 1, false);
		sprite_index = spr_drybones_defeated;
		image_speed = 0;
		image_xscale = 1;
	}

	// Stomp: knocks it apart and Mario bounces (ev. 209).
	if(!ossa && !defeated && place_meeting(x, y - obj_player.currentY, obj_player)
	   && !obj_player.onGround && obj_player.y < (y - sprite_height / 2) && obj_player.currentY > 0) {
		ossa = true;
		ossaTempo = 0;
		xFermo = x;
		audio_play_sound(snd_dry_bones_hit, 1, false);

		obj_player.enemyBounce += 1;
		check_bounce();

		if(global.jumpHold)
			obj_player.currentY = -5;
		else
			obj_player.currentY = -1.5;
	} else if(!ossa && !defeated && place_meeting(x, y, obj_player)
	          && !obj_player.hitState && !obj_player.invincibilityState && !obj_player.itemCrash) {
		mario_damage(3);
	}
}
