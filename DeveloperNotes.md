# Developer Notes

This is the current handover for Playground Panic. It was refreshed from the repository contents on 15 September 2026. It is a source/layout inventory, not a claim that every gameplay idea in the old WIP notes is complete.

## Current project state

Playground Panic is a ZX Spectrum Next game written in NextBASIC, the NextBuildStudio/Boriel ZX Basic-derived compiled BASIC dialect. The project uses Next-specific graphics, sprite, Layer 2, bank-loading, keyboard/joystick, and audio features. PT3 tracker modules provide music; `data/game.afb` provides sound-effect data for the configured player.

The repository contains source and runtime assets, but not the NextBuildStudio toolchain or emulator. The existing VS Code/NextBuildStudio integration can build and run this checkout from the project folder. A locally generated `PlaygroundPanic.nex` and the `build/` directory may be present; both are ignored and should be treated as disposable outputs.

## Build entry point and dependencies

Compile `PlaygroundPanic.bas`. It:

1. Includes external NextBuild libraries: `nextlib.bas`, `nextlib_ints.bas`, `keys.bas`, and `string.bas`.
2. Includes the project modules listed below.
3. Loads the font, tile, sprite, player, SFX, and music banks.
4. Initialises sprites, SFX, music, interrupts, and the Next display registers.
5. Builds lookup/score tables and enters the main screen loop.

The external include files are not in this repository. The VS Code tasks in `.vscode/tasks.json` reference the separate NextBuild installation and CSpect setup used by the local development environment. Use the VS Code integration to compile/run here; check those paths when setting up another machine.

The source loads runtime files by bare filename—for example `PanicSprites.spr`, `game.afb`, and `game_theme_1.pt3`. The tracked copies are in `data/`. The emulator task mounts `data/` as the SD directory; real-hardware/emulator layouts must provide the same effective lookup path.

## Source map

| File | Actual role |
| --- | --- |
| `PlaygroundPanic.bas` | Entry point, asset loading, initialisation, screen dispatcher, main loop, initial high-score table. |
| `Constants.bas` | Shared constants and almost all global state, including sprite/tile/music IDs, timing, settings, player/NPC arrays, and default keys. |
| `Helpers.bas` | General sprite, sound, keyboard debounce, and formatting helpers. |
| `GameHelpers.bas` | Game-specific helpers, input helper `SpaceOrFire`, screen switching, NPC/player setup and behaviour, collisions, scoring/bonus text, and related logic. |
| `GameScreen.bas` | Level setup, player input/movement, timer, NPC updates, collisions, HUD, and level/life completion flow. |
| `Specials.bas` | Milk, snatcher, dog, dinner lady, cane, dust, and dog-poo spawning/update/cleanup. |
| `AttractScreen.bas` | Attract/title screen and animated demonstration. |
| `SettingsScreen.bas` | Start-game/settings menu, school-size and segregation choices, and navigation to key configuration. |
| `KeysScreen.bas` | Interactive UP/DOWN/LEFT/RIGHT key redefinition. |
| `LevelStartScreen.bas` | Level intro and between-level bonus text. |
| `LifeLostScreen.bas` | Life-lost message, bonus text, continue/abandon input. |
| `GameOverScreen.bas` | Game-over message and end-game bonus text. |
| `HiScoreListScreen.bas` | Displays the ten built-in high-score entries. |
| `HiScoreEntryScreen.bas` | Present screen stub; currently displays a prompt and returns to the game rather than implementing name entry. |
| `LoreScreen.bas` | Animated lore/character/item screen. |
| `CreditScreen.bas` | Credits screen. |
| `robs_nextlib.bas` | Checked-in NextBASIC/assembly library file, currently not included by the entry point. |

There is no `LevelEndScreen.bas`, `LevelCodeScreen.bas`, `_nextlib.bas`, `rob4.pt3`, `sync.bat`, or `NewScreen.bas` in this checkout. References to those names in older documentation are stale.

## Runtime flow

The program initially shows an attract screen. The dispatcher calls one handler once per frame after `WaitRetrace(1)`; each handler follows the pattern `init when gNeedInit=1 → update → read input → change music when gNeedInit=2` where applicable.

The implemented screen IDs and main transitions are:

- Attract → lore (after its timer) or settings (Space/Fire).
- Settings → level start, key configuration, or back to attract.
- Level start → game.
- Game → next level, life lost, or game over depending on timer/collision/lives.
- Life lost → game or game over.
- Game over → settings.
- Lore → high-score list; high-score list → credits after a timer or settings on input.
- Credits → settings on input or attract after its timer.

`JumpScreen()` sets the target and marks it for initialisation. Shared state is deliberately global and lives in `Constants.bas`; reset/ownership is distributed among the screen and helper routines.

## Controls and input

Default movement keys are O/P/Q/A (left/right/up/down), with Space as fire/continue. Kempston input is read from port 31 in settings and gameplay paths. The Keys screen can redefine the four movement keys. Space/Fire is handled by `SpaceOrFire()` with debounce logic.

The settings screen labels the joystick option “KEMPSTON STICK”. There is no separate, general input abstraction matching the old notes, and no verified support for other joystick/gamepad standards.

## Assets and banks

Tracked runtime assets are:

- `data/PanicSprites.spr` — sprite patterns.
- `data/tiles_8x8.spr` — tile patterns.
- `data/game.afb` — SFX data.
- `data/intro_attract_1.pt3`, `game_theme_1.pt3`, `game_theme_2.pt3`, `dead_1.pt3`, and four `level_*.pt3` files — music modules.

The font (`[]font8.fnt`) and player data (`[]ts4000.bin`) are referenced by the loader but are not tracked in this repository. Confirm where those files come from before distributing a runnable build. Bank numbers and the sprite/tile IDs are defined in `Constants.bas` and repeated in the loader's `LoadSDBank` calls.

## Sprite bank: `data/PanicSprites.spr`

`PanicSprites.spr` is a raw 16 KiB sprite bank: 64 indexed patterns × 256 bytes per pattern, with each pattern being a standard 16×16 sprite. There is no obvious file header; the first pattern is index 0. In the NBS sprite editor, think of the file as one sheet of 64 numbered 16×16 images, rather than as separate files for the player, NPCs, and objects.

The game initialises the bank with `InitSprites2(64, 0, BANK_SPRITES)`. Pattern indexes are the fourth argument to `UpdateSprite`; the third argument is the hardware sprite slot. Those two numbers are not the same thing. The normal hardware slots are: slot 0 for the player, slots 1–30 for ordinary NPCs, slots 31–37 for special objects/NPCs, and slots 40–49 for the ten possible dog-poo sprites (`POO_SPRITE_OFFSET = 40`).

### Pattern index map

| Pattern indexes | Contents | Animation layout |
| --- | --- | --- |
| 0–3 | Player | Walk, 4 frames |
| 4 | Player-related extra/unused pattern | Not used by the main animation code |
| 5 | Poo | Single static pattern |
| 6 | Dust cloud | Single static pattern |
| 7 | Milk bottle | Single static pattern |
| 8–11 | Player | Climbing up, 4 frames |
| 12 | Player-related extra/unused pattern | Not used by the main animation code |
| 13 | Cane | Single static pattern |
| 14–15 | Blank/reserved | No visible art in the checked-in bank |
| 16–19 | Player | Climbing down, 4 frames |
| 20 | Player-related extra/unused pattern | Not used by the main animation code |
| 21 | Bell | Single static pattern; defined as `BELLSPRITE` but not currently drawn by the game code |
| 22–23 | Blank/reserved | No visible art in the checked-in bank |
| 24–27 | Dog | Walk, 4 frames |
| 28–31 | Dog | Climbing up, 4 frames |
| 32–35 | Dog | Climbing down, 4 frames |
| 36–39 | Snatcher | Walk, 4 frames |
| 40–43 | Snatcher | Climbing up, 4 frames |
| 44–47 | Snatcher | Climbing down, 4 frames |
| 48–51 | Dinner lady | Walk, 4 frames |
| 52–55 | Dinner lady | Climbing up, 4 frames |
| 56–59 | Dinner lady | Climbing down, 4 frames |
| 60–63 | Blank/reserved | No visible art in the checked-in bank |

For the animated groups, frame 0 is the first index in the range and frame 3 is the last. The code advances the animation frame independently of movement direction: horizontal movement uses the walk group, while vertical movement uses the relevant climb-up or climb-down group. Left-facing characters normally reuse the same patterns with the sprite's horizontal mirror attribute set, so there is no second left-facing copy in the bank.

The constants that define the starts of these ranges are in `Constants.bas`: `PLAYERSPRITEWALK = 0`, `PLAYERSPRITECLIMBUP = 8`, `PLAYERSPRITECLIMBDOWN = 16`, `DOGSPRITEWALK = 24`, `DOGSPRITECLIMBUP = 28`, `DOGSPRITECLIMBDOWN = 32`, `SNATCHERSPRITEWALK = 36`, `SNATCHERSPRITECLIMBUP = 40`, `SNATCHERSPRITECLIMBDOWN = 44`, `DINNERSPRITEWALK = 48`, `DINNERSPRITECLIMBUP = 52`, and `DINNERSPRITECLIMBDOWN = 56`. The player and NPC animation constants both set the frame count to 4.

The source also uses palette/attribute values to recolour the player and some NPCs, so an image can look different in-game without there being another pattern for that colour. `PLAYERANIMTIMER = 5` means the player animation advances every five waits/retraces; NPC animation timing is controlled separately by each NPC's speed state.

## Persistence and scoring

The high-score table is populated from a `DATA` block in `PlaygroundPanic.bas` at startup. No file-based high-score save/load is implemented. The high-score entry screen is not a complete name-entry system yet. Do not describe scores as persistent between runs.

## Known gaps and risks

- A clean build cannot be reproduced from this repository alone because the external NextBuild libraries/toolchain and emulator are not versioned here; the existing local VS Code integration supplies them.
- Runtime asset lookup depends on the SD/emulator working-directory layout; the source does not prefix loads with `data/`.
- Font and player-bank files are missing from tracked assets.
- `robs_nextlib.bas` may be useful reference code, but changing it will not affect the current build unless the include strategy is changed.
- `Constants.bas` contains an apparently incomplete `#define BANK_` line and other old comments/typos. Treat compiler behaviour as authoritative before cleaning these up.
- Music bank slots 46/47 are loaded from the same two game-theme files as slots 44/45; this may be intentional repetition, but is worth checking when adding tracks.
- There is no automated test suite. Behavioural verification is manual on a compatible emulator or real Spectrum Next.

The informal `rob-wip-notes.md.txt` contains useful historical bug reports and design ideas, but it also includes completed, superseded, and speculative items. Validate each item against the code before implementing it.

## Platform setup (initial pass)

These notes currently cover the author's Omarchy Quattro machine. The Windows and macOS paths still need to be added once they have been exercised and can be described accurately.

### Omarchy Quattro (Arch Linux)

#### 1. Install NextBuildStudio

Open the [NextBuildStudio downloads page](https://zxnext.uk/nextbuildstudio/#downloads) and download the Linux AppImage listed there. This file is an installer, not the application itself: running it sets up NextBuildStudio in its own app folder (at the time of writing, `~/Applications/NextBuildStudioV10`) and adds a launcher entry. It can be saved anywhere, such as `~/Downloads`, and deleted once you have confirmed the install works.

Install the Linux packages needed by NextBuildStudio/CSpect, AppImage support and the installer:

```bash
sudo pacman -S mono
sudo pacman -S fuse2
sudo pacman -S zenity
```

`zenity` is required by the installer. Without it, v1.1.25 exits silently (status 1) straight after logging `[1/8] Setting up directories`, with no error message, and installs nothing. If that happens, install `zenity` and run the installer again.

Make the downloaded AppImage executable, then run it. Replace the example filename with the actual filename downloaded from the page (for example `NextBuildStudioV10-x86_64-1.1.25.AppImage`):

```bash
cd ~/Downloads
chmod +x NextBuildStudio-<version>.AppImage
./NextBuildStudio-<version>.AppImage
```

Follow the NextBuildStudio setup prompts. This installs/sets up the NBS software and its integrated VS Code workflow, and NextBuildStudio should then appear in the application launcher. The exact AppImage filename and version will change over time, so do not hard-code them into project scripts without checking the downloads page.

#### 2. Install and authenticate GitHub CLI

Install `gh` from the Arch repositories:

```bash
sudo pacman -S github-cli
```

Start GitHub CLI authentication:

```bash
gh auth login
```

In the prompts, choose:

1. `GitHub.com`.
2. `HTTPS` for the Git protocol.
3. `Login with a web browser`.

GitHub CLI will display a one-time code and open, or ask you to open, a browser page. Copy the code into the browser, sign in to the GitHub account that should access the repository, and authorise the CLI. Back in the terminal, `gh` should report that authentication succeeded. Check the result with:

```bash
gh auth status
```

#### 3. Clone the source

Create a `road` folder in the home directory, enter it, and clone the repository:

```bash
mkdir -p ~/road
cd ~/road
gh repo clone weareroad/playgroundpanic
cd ~/road/PlaygroundPanic
```

The local checkout should now be at `~/road/PlaygroundPanic`. Open that folder in NextBuildStudio/its VS Code integration, then use the existing build/run tasks described in `.vscode/tasks.json`. Keep the `data/` directory beside the source files when running the game.

## Suggested first tasks for a new contributor

1. Use the existing VS Code integration to reproduce the build, then document the NextBuildStudio/NextBuild and CSpect setup when convenient.
2. Confirm the required external include files, font, and player asset, and document their source/licensing.
3. Test asset lookup from both the emulator task and a real SD-card layout.
4. Exercise each screen transition, input remapping, level timer, special item, collision, and audio change.
5. Only then promote items from `rob-wip-notes.md.txt` into a prioritised issue/backlog.

## Change checklist

- Keep shared IDs, timings, and state in `Constants.bas` where appropriate.
- Preserve the include order in `PlaygroundPanic.bas` unless the compiler requires a deliberate change.
- Keep frame-loop work bounded and avoid file I/O during gameplay.
- If changing assets or bank IDs, test the complete loader and runtime lookup path.
- Compile using the VS Code/NextBuildStudio integration; for runtime-sensitive changes, also run on CSpect or hardware.
- In a handover or pull request, distinguish verified behaviour, untested assumptions, and planned work.
