# Playground Panic (ZX Spectrum Next)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Docs](https://img.shields.io/badge/Docs-Developer%20Notes-blue)](DeveloperNotes.md)
[![WIPs](https://img.shields.io/badge/WIP-Notes-orange)](rob-wip-notes.md)
![Project Status: Alpha](https://img.shields.io/badge/Status-Alpha-red.svg)

<p align="center">
  <a href="https://www.specnext.com">
    <img src="assets/spectrum-next-logo-300x72.png" alt="Spectrum Next logo" width="300">
  </a><br>
  <sub><i>ZX Spectrum Next logo by Rick Dickinson, used with respect for the Spectrum Next project.</i></sub>
</p>

_A fast, arcade-style playground caper for the **ZX Spectrum Next**_

> Repo: `weareroad/PlaygroundPanic` (flat layout with screens split into multiple `.bas` files, plus a `data/` folder containing graphics (sprites, tiles), sound effects and PT3 tracks).

- **Platform:** ZX Spectrum Next (real hardware or CSpect / ZEsarUX)  
- **Language:** NextBASIC Studio (Boriel Basic, with 'Next' features) 


## Documentation
- [Developer Notes](DeveloperNotes.md)  
- [Robs WIP Notes](rob-wip-notes.md)  


## Premise

The bell rings. Chaos erupts. Keep order on the playground—shepherd kids, dodge hazards, and survive the recess timer. Earn points for tidy routes and quick clears.


## Controls

Controls are configurable (see the **Keys** screen). A common default is:

- **Left/Right:** `O` / `P`  
- **Jump/Action:** `Q` / `A` or `SPACE`  
- **Pause:** `SPACE` • **Quit:** `ESC` (on a default CSpect setup this will kill the emulator)  


## Current repository contents

The following is an up-to-date snapshot of the files currently in the repository. Generated build output and the `assets/` folder are intentionally omitted here.

```
/
├── AGENTS.md # for Codex/Claude
├── AttractScreen.bas # Title/attract loop
├── Constants.bas # Game constants (palettes, sprite ids, speeds…)
├── CreditScreen.bas # Credits
├── DeveloperNotes.md # Onboarding/orientation for devs
├── GameHelpers.bas # Gameplay helpers (spawning, collisions) 
├── GameOverScreen.bas # Gam over sequence
├── GameScreen.bas # Main gameplay loop
├── Helpers.bas # Other helpers
├── HiScoreEntryScreen.bas # INCOMPLETE high-score entry screen
├── HiScoreListScreen.bas # Guess what? High-score list
├── KeysScreen.bas # CHange keyboard controls screen
├── LICENSE # MIT license
├── LevelStartScreen.bas # Pulled up at the start of a level
├── LifeLostScreen.bas # Pulled up at the end of a life/level
├── LoreScreen.bas #  One of the intro/attract screens
├── PlaygroundPanic.bas # MAIN ENTRY POINT
├── README.md # this file
├── SettingsScreen.bas # config the game THESE ARE NOT PERSISTED YET
├── Specials.bas # handling for some of the NPC behaviour
├── rob-wip-notes.md.txt # out of date notes, need compiling into DeveloperNotes
├── robs_nextlib.bas # now unused, a patch file for previous version of NBS
└── data/
    ├── PanicSprites.spr # main sprites file
    ├── dead_1.pt3 # music played when you 'die'
    ├── game.afb # sound effects file
    ├── game_theme_1.pt3 # temp game intro theme
    ├── game_theme_2.pt3 # another game intro theme
    ├── intro_attract_1.pt3 # and another one - not sure which ones are used
    ├── level_dywmb.pt3 # Dont You Want Me Baby sting
    ├── level_eott.pt3 #  Eye Of The Tiger sting
    ├── level_tcm.pt3 # don't recall this one off-hand
    ├── level_tm.pt3 # The Model sting
    └── tiles_8x8.spr # sprite tiles (used for backgrounds, static graphics etc)
```

## This is a **NextBasicStudio** project:

## Roadmap (suggested)

- Gamepad/Joypad support & on-screen mapping help  
- Balance passes: spawn timing, hazards, NPC behavior  
- High-score save to disk (NextZXOS file)  
- In-game audio toggle; additional PT3 tracks  
- Color-palette accessibility presets


## Troubleshooting after code changes

- **Black screen/return to BASIC:** check that `_nextlib.bas` is loaded/merged before screens needing Next registers; verify `data/` path.  
- **No music:** emulator AY disabled or PT3 player not invoked on the relevant screen.  
- **Slowdowns:** reduce simultaneous sprites or expensive collision checks in `GameHelpers.bas`; precompute tables in `Helpers.bas`.


## Acknowledgments

The **ZX Spectrum Next** logo was created by the late **Rick Dickinson** and is used here with respect to the Spectrum Next project.  
Logo assets were obtained from the [official Spectrum Next website](https://www.specnext.com/spectrum-next-logo/) and converted to PNG format for inclusion in this repository.  
The logo is a trademark of the Spectrum Next team and is reproduced here solely for documentation and attribution purposes.


## Contributing

PRs and issues welcome. Please:

1. Keep `.bas` lines readable (labels + comments for key registers/ports).  
2. Group hardware `POKE`/`PORT` code inside `_nextlib.bas` where possible.  
3. Include emulator steps when filing bugs.

## License

This project is licensed under the [MIT License](LICENSE).

**Additional condition:** derivative works may not be distributed under the
name **Playground Panic**. The name is reserved by the original authors.





