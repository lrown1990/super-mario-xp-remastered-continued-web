// Mammoth Flower - the stage 2 boss.
// The numbers come from the original's events, level 22 "2-7".
// See port/marioxp-originale/BOSS-PIANTA-SPECIFICA.md

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

// the exit on the right stays shut while the boss is alive
instance_deactivate_object(obj_screen_advance);

active = true;
defeatedTimeout = 0;
defeatedMusic = false;
