# Agent guidance for Playground Panic

## Project at a glance

Playground Panic is a ZX Spectrum Next game. The source is written in NextBASIC: a NextBuildStudio/Boriel ZX Basic-derived, compiled BASIC dialect with Spectrum Next extensions. Music is in PT3 tracker format and is played through the AY/PT3 support supplied by the NextBuild environment.

This repository is the game source and its runtime assets. It is not a self-contained NextBuildStudio installation.

## Source of truth

- `PlaygroundPanic.bas` is the entry point and the only project source that should be compiled directly. It loads banks, initialises the Next hardware/sprite/audio systems, includes the other project modules, then runs the main screen loop.
- The other `.bas` files are included source fragments, not independent programs. Keep their names and case aligned with the `#include` statements.
- `Constants.bas` owns the shared constants, global state, sprite/tile IDs, timing values, and key defaults. `Helpers.bas` contains general helpers; `GameHelpers.bas` contains game-aware helpers; `Specials.bas` handles special items/NPCs.
- Screen modules expose `Handle...Screen` routines and use `gNeedInit` for one-time screen initialisation. Use `JumpScreen(...)` for screen changes.
- Runtime assets are in `data/`: sprites, tiles, sound effects, and PT3 music. `assets/` currently contains the Spectrum Next logo used by the README and a placeholder asset note.
- `robs_nextlib.bas` is a checked-in library/reference file, but `PlaygroundPanic.bas` currently includes external `<nextlib.bas>`, `<nextlib_ints.bas>`, `<keys.bas>`, and `<string.bas>` instead. Do not assume `robs_nextlib.bas` is active.

## Build and run

The intended workflow is NextBuildStudio/NextBuild through the VS Code tasks in `.vscode/tasks.json`. The local development setup can build and run this checkout through that integration. The toolchain and emulator are external rather than bundled here, so a fresh contributor still needs an equivalent NextBuildStudio/VS Code setup and library include path.

The relevant task names are:

- `Compile ZXbasic` — compile `PlaygroundPanic.bas`.
- `Run in Cspect` — compile, then launch CSpect with the `data/` directory mounted.
- `Generate TAP` / `Run compiled TAP` — legacy/alternate tasks; verify their paths before relying on them.

The loader calls `LoadSDBank` with bare asset names such as `PanicSprites.spr` and `game_theme_1.pt3`. In the repository those files are under `data/`, so the SD/emulator working directory or mounted layout must make those names resolvable. Keep this in mind when diagnosing “file not found” or blank-screen failures.

`PlaygroundPanic.nex` and `build/` are ignored generated outputs. They may exist locally, but they are not the authoritative build and are not committed by default.

## Working conventions

- Make the smallest change that solves the task; this is timing-sensitive 8-bit game code.
- Preserve NextBASIC syntax and the existing lower-case `sub`/`function` style unless a change requires otherwise.
- Prefer existing shared constants and helpers over new magic numbers. Hardware-specific operations belong in the Next library layer or a clearly marked assembly block.
- Keep per-frame work bounded. Avoid file I/O, allocations, or expensive calculations inside the main game update path.
- If changing a sprite, tile, sound, or music ID, update the corresponding `Constants.bas` definition and verify the asset bank loaded by `PlaygroundPanic.bas`.
- Treat the current screen and gameplay behaviour as implementation, not as a promise made by the older notes. Confirm behaviour in an emulator or on hardware when the toolchain is available.
- Do not rename or remove assets/modules merely to match stale documentation without checking all includes and runtime loads first.

## Verification expectations

For source changes, at minimum:

1. Check `git diff` and confirm no unrelated generated files are being added.
2. Compile with the configured NextBuildStudio/NextBuild toolchain when available; the existing VS Code integration is the expected route.
3. Run the game in CSpect or on real hardware for changes affecting screen flow, input, timing, sprites, collisions, or audio.
4. Report toolchain/emulator limitations explicitly rather than claiming a runtime test that was not performed.

## Documentation hygiene

`DeveloperNotes.md` is the contributor handover and should describe verified current structure and behaviour. Planned work belongs in a clearly labelled backlog. `rob-wip-notes.md.txt` is the original developer's informal, partly stale scratchpad; use it as historical context, not as a specification.
