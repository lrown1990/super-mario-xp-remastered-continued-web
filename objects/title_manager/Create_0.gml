currentOption = 1;
cursorMoved = false;
selected = false;

timeout = 0;

image_speed = 0.2;

menu_cursor = spr_title_cursor;

audio_stop_all();

// C'e' una partita salvata? Si guarda il contenuto grezzo del salvataggio e
// non lo stadio raggiunto: "c'e' qualcosa da perdere" e' esattamente "la
// stringa non e' vuota". Questa lettura sta PRIMA di load_property apposta,
// perche' quello, quando trova dei dati, esce senza chiudere il file.
ini_open("save_data.xp");
hasSave = (ini_read_string("save-data", "content", "") != "");
ini_close();

stageCount = load_property("currentStage");

// Riquadro di conferma di "New game", disegnato nel Draw e comandato nello
// Step. Il NO parte in evidenza: chi tira dritto non cancella niente.
confirming = false;
confirmYes = false;
confirmMoved = true;