'!org=24576
' NextBuild Layer2 Template 


' PLAYGROUND PANIC (was APOCALYPSE BREAKTIME)
' Robsoft / Road 2024
'
'
#DEFINE NEX 
#DEFINE IM2 

#INCLUDE <nextlib.bas>
#INCLUDE <nextlib_ints.bas>
#INCLUDE <keys.bas>
#INCLUDE <string.bas>
#INCLUDE "Constants.bas"
#INCLUDE "Helpers.bas"

SetupNext()
CLS256(COLOR_BLACK)

LoadSDBank("[]font8.fnt", 0, 0, 0, 32) ' BANK_FONT - was .SPR, now .FNT
LoadSDBank("tiles_8x8.spr", 0, 0, 0, 34) ' BANK_TILES
LoadSDBank("PanicSprites.spr", 0, 0, 0, 36) ' BANK_SPRITES
LoadSDBank("game.afb",0,0,0,41)  ' BANK_SFX
LoadSDBank("[]ts4000.bin",0,0,0,42) ' BANK_PLAYER

LoadSDBank("intro_attract_1.pt3",0,0,0,43) 'MUSIC_ATTRACT
LoadSDBank("game_theme_1.pt3",0,0,0,44) 'MUSIC_GAME_1
LoadSDBank("game_theme_2.pt3",0,0,0,45) 'MUSIC_GAME_2
LoadSDBank("game_theme_1.pt3",0,0,0,46) 'MUSIC_GAME_3
LoadSDBank("game_theme_2.pt3",0,0,0,47) 'MUSIC_GAME_4
LoadSDBank("dead_1.pt3",0,0,0,48) 'MUSIC_ENDGAME
LoadSDBank("level_dywmb.pt3",0,0,0,49) 'MUSIC_LEVEL_1
LoadSDBank("level_eott.pt3",0,0,0,50) 'MUSIC_LEVEL_2
LoadSDBank("level_tm.pt3",0,0,0,51) 'MUSIC_LEVEL_3
LoadSDBank("level_tcm.pt3",0,0,0,52) 'MUSIC_LEVEL_4


InitSprites2(64, 0, BANK_SPRITES)
InitSFX(41)
gCurrentTrack = MUSIC_ATTRACT
gLastTrack = gCurrentTrack
InitMusic(42, gCurrentTrack, 0000)
SetUpIM()
PlaySFX(0)

EnableSFX
EnableMusic

#include "GameHelpers.bas"

' initial landing page
for n = 9 to 21
  DoTileBank8(n, 12, TILE_BLACK_BACKGROUND, BANK_TILES)
  DoTileBank8(n, 13, TILE_BLACK_BACKGROUND, BANK_TILES)
  DoTileBank8(n, 14, TILE_BLACK_BACKGROUND, BANK_TILES)
next n
L2Text(9, 9, "STOP THE TAPE!", BANK_FONT, 0)
L2Text(8, 12, "PRESS SPACE/FIRE", BANK_FONT, 0)
do 
  asm
    halt
  end asm
loop until SpaceOrFire()=1


#include "AttractScreen.bas"
#include "SettingsScreen.bas"
#include "GameOverScreen.bas"
#include "Specials.bas"
#include "LifeLostScreen.bas"
#include "GameScreen.bas"
#include "LevelStartScreen.bas"
#include "HiScoreEntryScreen.bas"
#include "HiScoreListScreen.bas"
#include "KeysScreen.bas"
#include "LoreScreen.bas"
#include "CreditScreen.bas"

GenerateLookupTables()
GenerateScoreTable()
GameInit()

' would load scores, keys etc from prefs here in future

JumpScreen(ATTRACTSCREEN)

CLS256(COLOR_BACKGROUND)


' MAIN GAME LOOP
do
  WaitRetrace(1)

  if screenType=GAMESCREEN
    HandleGameScreen()
  elseif screenType=LEVELSTARTSCREEN
    HandleLevelStartScreen()
  elseif screenType=GAMEOVERSCREEN
    HandleGameOverScreen()
  elseif screenType=LIFELOSTSCREEN
    HandleLifeLostScreen()
  elseif screenType=ATTRACTSCREEN
    HandleAttractScreen()
  elseif screenType=SETTINGSSCREEN
    HandleSettingsScreen()
  elseif screenType=LORESCREEN
    HandleLoreScreen()
  elseif screenType=HISCORELISTSCREEN
    HandleHiScoreListScreen()
  elseif screenType=HISCOREENTRYSCREEN
    HandleHiScoreEntryScreen()
  elseif screenType=KEYSSCREEN
    HandleKeysScreen()
  elseif screenType=CREDITSCREEN
    HandleCreditScreen()
  else
    ' debug/fallthru handler'
    if endGame<>255
      L2Text(1, 1, "ALL OK, LOOPING", BANK_FONT, 0)
      endGame=255
    endif
  endif   
  
loop




sub GenerateLookupTables()
  dim n as UINTEGER '  if you don't set this as UINTEGER, the for-loop will fail

  for n = 0 to 320
    tInts(n) = cast(INTEGER, n)
  next n

  for n = 0 to 12
    tSqrs(n) = cast(INTEGER, n*n)
  next n
end sub  

sub GenerateScoreTable()
  restore scoredata
  dim n as ubyte
  for n=1 to 10
    read gHiNames(n), gHiScores(n)
  next n
end sub
scoredata:
  data "ROBSOFT",10000,"OLIVIA",9500 
  data "LOUISE",9000,"ANGUS",8500 
  data "BONNIE",8000,"SCOOBY",7500 
  data "KEITH",7000,"COLIN",6500 
  data "KEN",6000,"KEVIN",5500 

sub SetupNext()
  asm 
    ; setting registers in an asm block means you can use the global equs for register names 
    ; 28mhz, black transparency, sprites on over border, 256x192
    nextreg TURBO_CONTROL_NR_07,%11         ; 28 mhz 
    nextreg GLOBAL_TRANSPARENCY_NR_14,$0    ; black 
    nextreg SPRITE_CONTROL_NR_15,%01000011  ; %000    sprite 0 on top S L U, %11 sprites on over border
    nextreg LAYER2_CONTROL_NR_70,$0  ; 5-4 %00 = 256x192
  end asm 
end sub

