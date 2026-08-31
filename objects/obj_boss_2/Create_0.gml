// Mammoth Flower - boss dello stadio 2.
// I numeri vengono dagli eventi dell'originale, livello 22 "2-7".
// Vedi port/marioxp-originale/BOSS-PIANTA-SPECIFICA.md

depth = 30;

damagePoints = 18;

riseLimit = 160;
sinkLimit = 260;

sinking = false;
slammed = false;
fallSpeed = 0;
fleeDir = 0;

chaseTimer = 0;
slamTimer = 0;
slamDelay = random_range(2.3, 3.0);
tentacleTimer = 0;
bobTime = 0;

currentAnim = "idle";
animationTimeout = 0;

// l'uscita a destra resta chiusa finche' il boss e' vivo
instance_deactivate_object(obj_screen_advance);

active = true;
defeatedTimeout = 0;
defeatedMusic = false;
