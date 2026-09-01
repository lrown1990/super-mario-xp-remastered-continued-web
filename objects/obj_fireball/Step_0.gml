if(!global.playerDead) {
	x += fireballSpeed * fire_direction;

	// Gravity applies to both characters. It used to sit inside a switch
	// with only the "mario" case, so Luigi's fire flew straight and never
	// bounced: the bounce off the ground is conditional on currentY > 0,
	// which without gravity never happens. The green colour has nothing to
	// do with it, that lives in the Draw event and in the particles.
	currentY += 0.2;

	currentAngle += 20 * -fire_direction;

	y += round(currentY);

	image_alpha = 0;
	depth = -500;

	if(place_meeting(x, y + currentY + 1, obj_ground_group) && currentY > 0) {
		while(!place_meeting(x, y + 1, obj_ground_group)) {
			y += 1;
		}
		currentY = -2;
	}

	if(place_meeting(x + round(fireballSpeed), y, obj_ground_group)) {
		while(!place_meeting(x + sign(fireballSpeed), y, obj_ground_group)) {
			x += sign(fireballSpeed);
		}
		audio_play_sound(snd_fireball_impact, 1, false);
		var instance = instance_create_layer(x, y, "Objects", obj_fireball_explosion);
		instance.emitter = emitter;
		instance_destroy();
	}
	particleTimeout -= delta_time / 1000000;

	if(particleTimeout <= 0) {
		particleTimeout = 0.1;
		switch(emitter) {
			case "mario": {
				var particle = instance_create_layer(x, y, "Objects", obj_weapon_particle);
				particle.weapon_type = "fire";
				break;
			}
			
			case "luigi": {
				var particle = instance_create_layer(x, y, "Objects", obj_weapon_particle);
				particle.weapon_type = "luigi_fire";
				break;
			}
		}
	}

	if(x < camera_get_view_x(view_camera[0]) - 30 || 
	   x > camera_get_view_x(view_camera[0]) + camera_get_view_width(view_camera[0]) + 30 ||
	   y < camera_get_view_y(view_camera[0]) - 30 || 
	   y > camera_get_view_y(view_camera[0]) + camera_get_view_height(view_camera[0]) + 30) {
		   instance_destroy();
	}

}