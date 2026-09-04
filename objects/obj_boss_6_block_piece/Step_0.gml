if(global.playerDead) {
	image_speed = 0;
	return;
}

vy += GRAVITA;
x += vx;
y += vy;
image_angle -= 15;

if(y > room_height + sprite_height)
	instance_destroy();
