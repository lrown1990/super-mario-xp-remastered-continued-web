function save_run_state(){
	// The state of the run (lives, weapon, hearts, health) is written to the
	// save at the START OF EVERY LEVEL, not only when a stage is finished.
	// Before, the save stood still at the last boss beaten: reach a boss with
	// plenty of lives and a full heart counter and you could replay the rest of
	// the stage on that, reloading from the menu every time, however badly it
	// had gone in between. Written on every entry, the save follows the run.
	//
	// The stage reached is NOT touched here: replaying an old stage must not
	// walk the progress backwards. Only level_finished raises that, and only
	// when the number is higher.
	var mappa = ds_map_create();
	ini_open("save_data.xp");

	var esistente = ini_read_string("save-data", "content", "");
	if(esistente != "")
		ds_map_read(mappa, esistente);

	ds_map_set(mappa, "lives", global.playerLives);
	ds_map_set(mappa, "weapon", global.playerWeapon);
	ds_map_set(mappa, "hearts", global.hearts);
	ds_map_set(mappa, "health", global.pHealth);

	ini_write_string("save-data", "content", ds_map_write(mappa));
	ini_close();
	ds_map_destroy(mappa);
}
