// The red Boo (レッドテレサ in the original, Boss_02 of level 31).
// It does NOT circle around the orb: it heads straight for its centre, then
// moves away up to a certain distance, then comes back. Each one has its
// own direction and its own timing, so the cloud pulses instead of
// rotating.
// When the orb throws itself at the ground it flings them all outwards, and
// on the way back up it calls them in again.

depth = 28;

image_speed = 0;       // one frame per facing, not an animation

direzione = irandom(359);              // which ray it travels along
distanzaMax = 26 + irandom(34);        // how far out before coming back
fase = random(2 * pi);                 // where it is in its own back and forth
velFase = 1.4 + random(1.4);           // radians per second
velInseguimento = 80 + irandom(70);    // pixels per second

// The orb has two attacks and treats them differently:
// - SPIRAL: they spread out SPINNING around the room, without leaving
// - AWAY: they shoot out STRAIGHT, along their own direction, until the
// room is clear
distanzaLancio = 0;
velRotazione = choose(-1, 1) * (55 + irandom(70));   // degrees per second
velUscita = 130 + irandom(60);                       // how fast it leaves

versoUltimo = 0;
