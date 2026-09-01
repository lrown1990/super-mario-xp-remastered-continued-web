currentOption = 1;
cursorMoved = false;
selected = false;

timeout = 0;

image_speed = 0.2;

menu_cursor = spr_title_cursor;

audio_stop_all();

// Is there a saved game? It looks at the raw contents of the save and not
// at the stage reached: "there is something to lose" is exactly "the string
// is not empty". This read sits BEFORE load_property on purpose, because
// that one, when it finds data, returns without closing the file.
ini_open("save_data.xp");
hasSave = (ini_read_string("save-data", "content", "") != "");
ini_close();

stageCount = load_property("currentStage");

// Confirmation box for "New game", drawn in the Draw event and driven in
// the Step. NO starts highlighted: anyone hammering through deletes
// nothing.
confirming = false;
confirmYes = false;
confirmMoved = true;