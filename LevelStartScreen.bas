
sub HandleLevelStartScreen()
  if gNeedInit=1 then InitLevelStartScreen()
  UpdateLevelStartScreen()
  ReadLevelStartKeyboard()
  if gNeedInit=2 ChangeMusic()
end sub


sub InitLevelStartScreen()
  AllSpritesOff()
  
  CLS256(COLOR_BACKGROUND)

  if gLevel>1 then
    L2Text(1, 1, "  YOU SURVIVED BREAK-TIME...", BANK_FONT, 0)
    GenEndLevelBonusText()
    L2Text(1, 4,"YOUR PRIZE;", BANK_FONT, 0)
    L2Text(2, 6, gBonusText(1), BANK_FONT, 0)
  else
    L2Text(1, 1, "  SURVIVE BREAK-TIME...!", BANK_FONT, 0)
  endif

  dim m$ as string = right("00"+str(gLevel mod 100),2)
  L2Text(1, 10, "        LEVEL " +m$+" START", BANK_FONT, 0)

  L2Text(15, 22, "PRESS SPACE/FIRE", BANK_FONT, 0)

  gCurrentTrack = cast(ubyte,MUSIC_LEVEL_1 + ((gLevel-1) mod MUSIC_TRACKS_COUNT)) 
  gNeedInit=2
end sub


sub UpdateLevelStartScreen()
end sub


sub ReadLevelStartKeyboard()
if SpaceOrFire()=1 then JumpScreen(GAMESCREEN)
end sub
