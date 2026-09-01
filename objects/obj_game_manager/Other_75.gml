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

audio_stop_all();
room_goto(title_screen);
