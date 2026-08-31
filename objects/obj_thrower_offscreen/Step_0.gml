if(!instance_exists(obj_player))
	return;

// Fuori dal tratto il conto sta fermo, come in obj_thrower quando il cannone
// e' fuori inquadratura: non riparte da capo, riprende da dov'era.
if(obj_player.x >= fromX && obj_player.x <= toX)
	counter += delta_time / 1000000;

if(counter >= period) {
	counter = 0;

	var vx = camera_get_view_x(view_camera[0]);
	var vy = camera_get_view_y(view_camera[0]);
	var vw = camera_get_view_width(view_camera[0]);

	// Appena fuori dal bordo destro, e TASSATIVAMENTE di poco.
	// obj_bullet_bill si distrugge da solo appena esce dall'inquadratura, e il
	// margine che si concede e' "sprite_width + 32". Quello pero' e' lo sprite
	// SCALATO, e appena il proiettile punta a sinistra image_xscale diventa -1:
	// il margine si rovescia e diventa una tolleranza di soli 14 pixel. Nato a
	// +20 spariva al secondo passo, prima ancora di entrare in campo (misurato:
	// zero proiettili vivi in quaranta secondi di prova). A +8 il proiettile
	// entra dal bordo e resta.
	// Il verso non si imposta qui: il Create di obj_bullet_bill punta verso
	// Mario, che da questa posizione e' sempre a sinistra.
	instance_create_layer(vx + vw + 8, vy + rowFirst + irandom(rows - 1) * 16, "Objects", obj_bullet_bill);

	audio_play_sound(snd_impact_generic, 1, false);
}
