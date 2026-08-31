if(!global.playerDead) {
	x += fireballSpeed * fire_direction;

	// La gravita' vale per tutti e due i personaggi. Prima stava dentro uno
	// switch con il solo caso "mario", quindi il fuoco di Luigi volava dritto
	// e non rimbalzava mai: il rimbalzo a terra e' condizionato a currentY > 0,
	// che senza gravita' non si verifica. Il colore verde non c'entra, sta nel
	// Draw e nelle particelle.
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