sub HandleHiScoreListScreen()
  if gNeedInit = 1 then  InitHiScoreListScreen()
  UpdateHiScoreListScreen()
  ReadHiScoreListKeyboard()
  if gNeedInit=2 then ChangeMusic()
end sub


sub InitHiScoreListScreen()
  AllSpritesOff()
  PlayerSpriteOff()
  
  CLS256(COLOR_BACKGROUND)
  tSettings = 2000
  L2Text(1, 1, "      PLAYGROUND PANIC", BANK_FONT, 0)
  L2Text(1, 3, "   THE MOST-SLIPPERY KIDS", BANK_FONT, 0)
  L2Text(15, 22, "PRESS SPACE/FIRE", BANK_FONT, 0)

  ' todo: centre the text of the name, right-align the score value
  dim n as ubyte
  for n=1 to 3
    L2Text(3, 6+n, PadUByte(n,2), BANK_FONT, 0)
    L2Text(7, 6+n, gHiNames(n), BANK_FONT,0)
    L2Text(19, 6+n, PadULong(gHiScores(n),9), BANK_FONT, 0)
  next n

  ' first 3 are pulled out a little from the rest'
  for n=4 to 10
    L2Text(3, 8+n, PadUByte(n,2), BANK_FONT, 0)
    L2Text(7, 8+n, gHiNames(n), BANK_FONT,0)
    L2Text(19, 8+n, PadULong(gHiScores(n),9), BANK_FONT, 0)
  next n

  gNeedInit = 0
end sub

sub UpdateHiScoreListScreen()
  tSettings = tSettings - 1 
  if tSettings = 0 '  time to move on?
    JumpScreen(LORESCREEN)
    return
  endif
end sub

sub ReadHiScoreListKeyboard()
  if SpaceOrFire()=1 then JumpScreen(SETTINGSSCREEN)
end sub

