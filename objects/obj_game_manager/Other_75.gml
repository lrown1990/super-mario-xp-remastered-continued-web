/* ---------- Messaggi dalla pagina che ospita il gioco ----------
   Evento Async - System: il runtime HTML5 gira qui ogni window.postMessage,
   con il contenuto gia' convertito in stringa JSON.

   Serve una cosa sola: la voce "Exit and go to menu" della schermata di pausa,
   che la pagina disegna da se'. La pausa vera (congelare il gioco e zittire
   l'audio) la fa la pagina fermando il ciclo di disegno, e NON si fa da qui
   con instance_deactivate_all: provato, e non regge. Questo gioco e' pieno di
   letture diritte fra oggetti (obj_stage_manager.stage_fadeout,
   obj_player_sprite...), e in GML leggere una variabile su un oggetto che
   non ha istanze attive solleva un errore invece di dare undefined: appena si
   disattiva qualcosa, il primo che lo cerca fa morire il gioco. */
if (async_load[? "event_type"] != "post_message_received") exit;

var _grezzo = async_load[? "data"];
if (!is_string(_grezzo)) exit;

var _m = undefined;
try {
    _m = json_parse(_grezzo);
} catch (_e) {
    exit; // not one of ours
}

if (!is_struct(_m)) exit;
if (!variable_struct_exists(_m, "cvos") || _m.cvos != "mario") exit;
if (!variable_struct_exists(_m, "cmd") || _m.cmd != "menu") exit;

/* Leaving for the menu has to CLOSE the run, not just walk away from it.
   obj_game_manager is persistent, so its globals outlive the jump to the title
   screen: leave while global.playerDead is set, that is within the three
   seconds between dying and the lives screen, and the flag stays set for good.
   The next stage's obj_stage_manager then finds it straight away, counts its
   three seconds, takes a life off and sends you to the lives screen: the level
   starts and a few seconds later restarts itself with the lives of the run
   before. That is exactly what it looked like.
   What is cleared here is the RUN, not the save: the stage reached and the
   stage select list stay as they are. */
global.playerDead = false;
global.bossFermo = false;
global.startX = -1;
global.startY = -1;
global.initialWarping = false;
global.initialWarpDirection = "none";
global.screenToWarp = noone;
global.warpsEntered = [];
global.unUpPresi = [];

audio_stop_all();
room_goto(title_screen);
