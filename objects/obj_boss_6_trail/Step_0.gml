if(global.playerDead) {
	image_speed = 0;
	return;
}

// One pass and it is gone. Nothing in the original destroys Boss_03, so the
// object itself must carry the "destroy at the end of the animation" flag that
// Clickteam objects have; either way this is what it looks like in the game.
if(image_index >= image_number - 1)
	instance_destroy();
