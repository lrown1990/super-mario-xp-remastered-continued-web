// One link of the serpent's body. It does not move by itself: the head
// (obj_boss_4) drops a breadcrumb trail behind it and puts every link on it,
// which is what the original does with "position relative to the one before"
// plus a speed that drops link by link (ev. 161 and 162 of level 40).
depth = 31;                 // one behind the head, so the head reads on top

indice = 1;                 // 1..8, from the head backwards
sprite_normale = spr_boss_4_body;
sprite_colpito = spr_boss_4_body_damaged;
image_speed = 0;

colpito = false;
colpitoTimeout = 0;
