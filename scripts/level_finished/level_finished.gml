function level_finished(nextStage, weapon, hearts, playerHealth){
	savemap = ds_map_create();
	ini_open("save_data.xp");
	
	existing = ini_read_string("save-data", "content", "");
	
	if(existing != "")
		ds_map_read(savemap, existing);
	
	// GRAFFE OBBLIGATORIE. Senza, l'else si legava all'if INTERNO invece che a
	// quello esterno (dangling else): alla prima partita, quando la chiave non
	// esiste ancora, lo stadio non veniva salvato per niente e "Select Stage"
	// nel menu restava bloccato per sempre; e quando esisteva ma il nuovo
	// valore non era maggiore, veniva sovrascritto lo stesso, facendo
	// tornare indietro i progressi.
	if (ds_map_exists(savemap, "currentStage")) {
		if (nextStage > ds_map_find_value(savemap, "currentStage")) {
			ds_map_set(savemap, "currentStage", nextStage);
		}
	} else {
		ds_map_set(savemap, "currentStage", nextStage);
	}
	
	ds_map_set(savemap, "weapon", weapon);
	ds_map_set(savemap, "hearts", hearts);
	ds_map_set(savemap, "health", playerHealth);
	
	encryptedData = ds_map_write(savemap);
	ini_write_string("save-data", "content", encryptedData);
	
	ini_close();
}