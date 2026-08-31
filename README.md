# Super Mario XP Remastered, continued

Fork of [Matth33w's Super Mario XP Remastered](https://github.com/Matth33w/super-mario-xp-remastered),
the GameMaker remake of **Super Mario XP**, the game CnC Darkside released in 2001.
This fork picks up where he left off, and runs in the browser.

The project opens in **GameMaker LTS 2026** and is exported as HTML5.

## What this fork adds

### New content

- **Stage 2 boss (Mammoth Flower).** The boss room was empty. The fight is rebuilt from the
  event data of the 2001 original, not guessed from videos: 18 hit points, stomp 2, fireball 1,
  hammer 1, cross 2; it chases the player 1 pixel every 100 ms between x 60 and 900, sinks and
  resurfaces at a random x; tentacles come up faster as it takes damage (1800 / 1100 / 600 ms)
  and it drops four spores every 3 seconds. Sprites and sounds taken from the original game.
  New objects: `obj_boss_2`, `obj_boss_2_tentacle`, `obj_boss_2_spore`, plus 7 sprites and
  7 sounds. The stage exit stays closed until the boss is down.
- **Stage 3-1 bullet bill restored.** In the original, while the player is between x 1200 and
  3000, a bullet bill is fired from off screen every 3 seconds at a tile aligned random height.
  Back in, with a new object `obj_thrower_offscreen`. Heights are limited to the upper rows,
  where the shot is actually visible.
- **Character marker on the stage select map** for stages 1 to 3, drawn at the end point of the
  existing world map paths.
- **Confirmation before "New game"** when a save exists: *WARNING! All saved data will be lost.
  Proceed?*, with NO highlighted by default.
- **Options are remembered between sessions** (character, parallax, smooth transitions). They
  live in their own `[options]` section of `save_data.xp`, so starting a new game does not wipe
  them.
- **Character description in the Options screen**: BALANCED for Mario, FASTER, JUMPS HIGHER,
  WEAKER for Luigi.
- **Credits screen redone**: text only, one colour per name, and it can be skipped with Enter
  or Z.

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
  menu sits 12 pixels higher.
- The project was converted to GameMaker LTS 2026, which rewrites every `.yy` file. The real
  changes are 17 `.gml` files, three rooms (`demo`, `stage_2_7`, `stage_3_1`) and the resources
  listed above.

## Credits

- Original game, 2001: **CnC Darkside**
- GameMaker remake: **Matth33w**
- This fork: **Carlo Sinatra**
