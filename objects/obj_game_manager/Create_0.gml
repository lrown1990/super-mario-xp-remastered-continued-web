global.hearts = 10;
global.pHealth = 5;

global.heartsFont = font_add_sprite_ext(spr_heart_counter, "0123456789-", true, 2);
global.livesFont = font_add_sprite_ext(spr_lives_font, "0123456789-", true, 4);
global.whiteFont1 = font_add_sprite_ext(spr_font_stage_select, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-", true, 2);

global.pause = false;


global.playerDead = false;
global.debug = false;

global.currentStage = 1;

global.playerLives = 5;

global.playerWeapon = "none";

global.startX = -1;
global.startY = -1;

global.initialWarping = false;
global.initialWarpDirection = "none";

global.screenToWarp = noone;

global.warpsEntered = [];

global.character = "mario";

global.language = "eng";

set_soundtrack("remastered");

// Dipswitches
global.continuousMusic = true;
global.smoothTransitions = true;
global.parallaxScrolling = true;

global.oneHit = false;

// The preferences come back the way they were left last time. They live in
// the save file but in a SECTION of their own, "options": "New game" only
// empties the "content" key of the "save-data" section, so wiping the saved
// game leaves the settings where they are.
// The values above act as fallbacks: on a first run the file does not exist
// yet and ini_read_* returns exactly those.
ini_open("save_data.xp");
global.character = ini_read_string("options", "character", global.character);
global.parallaxScrolling = ini_read_real("options", "parallax", global.parallaxScrolling) > 0.5;
global.smoothTransitions = ini_read_real("options", "transitions", global.smoothTransitions) > 0.5;
ini_close();

// window_set_fullscreen(true);
surface_resize(application_surface, 320, 240);