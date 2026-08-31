// Il gioco aveva quattro colonne sonore (remaster, originale, SNES, Luigi)
// selezionabili da Opzioni. Sul sito e' rimasta solo la remaster e la voce
// di menu e' stata tolta, quindi i brani delle altre tre non servivano
// piu' e sono stati cancellati dal progetto: se si rimettessero i case
// qui, punterebbero ad asset che non esistono e il gioco non compila.
function set_soundtrack(soundtrack){
	global.bgm_stage_intro = bgm_stage_intro_remaster;
	global.bgm_stage1 = bgm_stage1_remaster;
	global.bgm_stage2 = bgm_stage2_remaster;
	global.bgm_stage3 = bgm_stage3_remaster;
	global.bgm_stage3_alt = bgm_stage3_alt_remaster;
	global.bgm_stage4 = bgm_stage4_remaster;
	global.bgm_stage5 = bgm_stage5_remaster;
	global.bgm_stage6 = bgm_stage6_remaster;
	global.bgm_stage7 = bgm_stage7;
	global.bgm_preboss = bgm_preboss_remaster;
	global.bgm_boss_intro = bgm_boss_intro_remaster;
	global.bgm_boss_loop = bgm_boss_loop_remaster;
	global.bgm_boss_defeated = bgm_boss_defeated;
	global.bgm_boss2 = bgm_boss_2_remaster;
	global.bgm_death_jingle = bgm_death_jingle_remaster;
}
