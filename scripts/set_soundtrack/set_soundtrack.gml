// The game had four soundtracks (remaster, original, SNES, Luigi)
// selectable from Options. On the site only the remaster is left and the
// menu entry has been removed, so the tracks for the other three were no
// longer needed and have been deleted from the project: putting the cases
// back here would point at assets that do not exist and the game would not
// compile.
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
