// La spora rossa: ne partono quattro quando la pianta tocca terra (ev. 383).
// direction e speed li imposta la pianta al momento della creazione.

depth = 28;

// vengono sparate verso l'alto e poi la gravita' le fa ricadere: e' la
// parabola che si vede nell'originale. Gravita' bassa: la spora galleggia
// invece di precipitare. Cambiandola va ricalcolata SPINTA in obj_boss_2,
// perche' l'altezza dell'arco e' spinta al quadrato diviso due volte questa.
gravity_direction = 270;
gravity = 0.08;
