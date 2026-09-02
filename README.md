# Super Mario XP Remastered, continued

Fork of [Matth33w's Super Mario XP Remastered](https://github.com/Matth33w/super-mario-xp-remastered),
the GameMaker remake of **Super Mario XP**, the game CnC Darkside released in 2001.
This fork picks up where he left off, and runs in the browser.

The project opens in **GameMaker LTS 2026** and is exported as HTML5.

## What this fork adds

### New content

- **Stage 4 boss (the sea serpent) and the two rooms that were missing.** Stage 4 stopped at 4-5:
  the pipe at the end of it led nowhere, and rooms 4-6 and 4-7 did not exist in the project at
  all. Both are rebuilt from the original's own level maps. The corridor 4-6 comes out at 1056
  differing pixels out of 153,600, all of them inside the pipe cells and the frames of the block
  animation; the arena background of 4-7 matches the map exactly. The fight follows the original:
  25 hit points, and a cycle of roughly three seconds. The serpent swims below the surface along
  a curve, leaps out where the player is, and then either bites, or hangs in the air with its
  mouth open for 1.2 seconds and spits three fireballs, or bounces off the bridge once or twice
  before dropping back in. Under 10 hit points the body falls away, and the head alone stays up
  on the bridge and keeps bouncing. Its mask is precise and contact damage is tested one step
  below the head, so a clean stomp costs the player nothing. New objects `obj_boss_4`,
  `obj_boss_4_segment`, `obj_boss_4_fireball`, `obj_splash`, rooms `stage_4_6` and `stage_4_7`,
  14 sprites and 3 sounds, the splash, the turn at the top of the leap and the roar, all from
  the original's own bank.
- **Stage 4 put back the way the original has it.** No block in stage 4 had its contents set, so
  every one of them fell back to the default. The placement data of the 2001 game was read back
  out of its level files and used to restore them, block by block. 4-2 now opens with a poison
  mushroom and a fire flower, has a hammer throwing turtle on the bridge and a cross near the
  end; the first "?" block of 4-3 gives a mushroom; 4-4 has its bullet bill, fired from the
  right at any height across the whole screen, along with the fire rods and the enemies that
  were missing from the end of it; 4-5 got its enemies back and the warp pipe that leads on to
  4-6. To let one object cover both cases, `obj_thrower_offscreen` now takes its range, its
  period and the band of rows it can fire at as instance variables, keeping the 3-1 numbers as
  its defaults.
- **Cheep cheeps break the surface.** Where there is water, a plume comes up wherever a fish
  crosses the water line, on the way out and on the way back in, using the same ten frame
  animation as the boss. Each fish reads the water line from the room it is in, so 2-3, where
  the fish jump over a bridge with nothing underneath, correctly stays dry, exactly as it is
  silent there in the original. Their mask is precise now as well.
- **A green mushroom is worth one extra life per run.** Take it, die, come back and hit the same
  block, and it gives a big heart instead. That covers all twenty of them, 11 in "?" blocks and
  9 in hidden blocks, whose default content is the green mushroom. It is the pickup that counts
  and not the hit, so dying while the mushroom is still bouncing around loses nothing, and the
  slate is wiped when a stage is started and on a new game.
- **Stage 2 boss (Mammoth Flower).** The boss room was empty. The fight is rebuilt from the
  event data of the 2001 original, not guessed from videos: 18 hit points, stomp 2, fireball 1,
  hammer 1, cross 2; it chases the player 1 pixel every 100 ms between x 60 and 900, sinks and
  resurfaces at a random x; tentacles come up faster as it takes damage (1800 / 1100 / 600 ms)
  and it drops four spores every 3 seconds. Sprites and sounds taken from the original game.
  New objects: `obj_boss_2`, `obj_boss_2_tentacle`, `obj_boss_2_spore`, plus 7 sprites and
  7 sounds. The stage exit stays closed until the boss is down.
- **Stage 3 boss (Nightmare) and its arena.** Walking into 3-7 used to drop the player on the
  game over screen. The room is now there, rebuilt pixel for pixel from the original's level
  map, and so is the fight: 30 hit points, stomp 5, fireball 1, hammer 1, cross 2, and the two
  attacks are the original's two timers. Every 8 seconds it dives to the floor, stays down
  4.10 seconds and flings the Boos around it straight out of the room; every 12.2 seconds it
  stays high and sends them off spinning instead. It opens with eighteen red Boos pulsing in
  and out along their own rays, and after 20 seconds it summons two Dry Bones through the side
  doors. New objects: `obj_boss_3`, `obj_boss_3_boo`, room `stage_3_7`, plus 5 sprites and
  4 sounds.
- **Dry Bones.** The sprites were already in the project but no object ever used them: it was
  the only stage 3 enemy that had never been ported. Now in 3-3, 3-5 and the boss arena, with
  the rules from the original's events: the fireball does nothing to it, stomp and hammer knock
  it apart and it puts itself back together after five seconds, and only the cross kills it. It
  turns around at walls only, and walks straight off ledges. New object `obj_dry_bones`.
- **World map walk for stages 4 to 7.** `obj_mario_world_map` only had paths for the first
  three stages, so from stage 4 on the character never moved. The four missing routes are
  recovered from the original: the starting point of each is the character's position on that
  stage's own Stage Map screen, and the route is traced frame by frame from recorded footage.
  New paths `path_mario_world_map_4` to `_7`.
- **Character marker on the stage select map**, for all seven stages. It is read from the last
  point of the matching world map path, so the marker cannot drift away from the walk.
- **Confirmation before "New game"** when a save exists: *WARNING! All saved data will be lost.
  Proceed?*, with NO highlighted by default.
- **Options are remembered between sessions** (character, parallax, smooth transitions). They
  live in their own `[options]` section of `save_data.xp`, so starting a new game does not wipe
  them.
- **Character description in the Options screen**: BALANCED for Mario, FASTER, JUMPS HIGHER,
  WEAKER for Luigi.
- **Credits screen redone**: text only, one colour per name, and it can be skipped with Enter
  or Z.
- **Stage 3-1 bullet bill restored.** In the original, while the player is between x 1200 and
  3000, a bullet bill is fired from off screen every 3 seconds at a tile aligned random height.
  Back in, with a new object `obj_thrower_offscreen`. Heights are limited to the upper rows,
  where the shot is actually visible.

### Fixes

- **Progress was never saved on a first playthrough.** In `level_finished` a dangling else meant
  that when the save key did not exist yet the stage was not written at all, so Stage Select
  stayed locked forever; and when it did exist, a lower stage could overwrite a higher one.
- **"New game" did not start a new game.** `obj_game_manager` is persistent, so its Create runs
  only once: after playing, New game resumed from the stage already reached, with the hearts and
  weapon of the previous run. It now resets stage, lives, hearts, health, weapon and warp state,
  and clears the saved game.
- **Opening the Options screen forced the character back to Mario**, because the menu indexes
  always started at zero and the step re-assigned the global from the highlighted row.
- **Luigi's fireball had no gravity**: the gravity line sat inside a switch with a "mario" case
  only, so his fireballs flew straight and never bounced.
- **Luigi threw two crosses instead of one.** Weapons now behave the same for both characters.
- **Mushrooms walked out of the room in 3-6.** The right hand side of that room is open, because
  that is the way into the boss arena: a mushroom released there walked past the end of the
  floor and dropped out of the world. Items now turn around at the edges of the room too.
- **The stage 3 boss could push the player through the ceiling.** Stomping it repeatedly while
  it rose moved the player up a few pixels at a time until he ended up above the room. He is now
  placed on top of the boss only where there is room for him.
- **Debug leftovers removed**: `show_debug_message` calls in `obj_player` and `obj_item_block`,
  `global.debug` turned off, F2 restart moved behind the debug flag.

### Web version specifics

Worth knowing before merging anything back:

- Only the remastered soundtrack is kept. The other three (original, SNES, Luigi) and the
  "Music style" option were removed, and 25 unused music assets deleted, to keep the browser
  build small.
- `obj_game_manager` has an **Async - System** event that listens to messages from the hosting
  page, used by the "exit to menu" entry of the web pause screen.
- The title screen no longer draws `spr_copyright` (a fake "©NINTENDO. KONAMI." notice) and the
  menu sits 12 pixels higher. The "Web port done by" line that used to sit under it is gone as
  well: the credit lives on the opening screen now.
- The stage select screen no longer prints "SMXP:R - SAGE 2022 DEMO", the label of a demo build
  made for an event this fork has nothing to do with.
- The project was converted to GameMaker LTS 2026, which rewrites every `.yy` file. The real
  changes are 47 `.gml` files, the rooms `demo`, `stage_2_7`, `stage_3_1`, `stage_3_3`,
  `stage_3_5`, `stage_3_6`, `stage_4_2`, `stage_4_3`, `stage_4_4`, `stage_4_5` and the new
  `stage_3_7`, `stage_4_6`, `stage_4_7`, and the resources listed above.

## Credits

- Original game, 2001: **CnC Darkside**
- GameMaker remaster: **Matth33w**
- This fork: **Carlo Sinatra**
