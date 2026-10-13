sub HandleGameOverScreen()
  if gNeedInit=1 then InitGameOverScreen()
  UpdateGameOverScreen()
  ReadGameOverKeyboard()
  
  if gNeedInit=2 then ChangeMusic()

end sub


sub UpdateGameOverScreen()
end sub


sub ReadGameOverKeyboard()
  if SpaceOrFire()=1 JumpScreen(SETTINGSSCREEN) 
end sub


sub InitGameOverScreen()
  PlayerSpriteOff()
  NPCSpritesOff(NO_RETAIN)
  SpecialSpritesOff()

  ''CLS256(COLOR_RED)
  ClearLayer2(COLOR_RED)

  L2Text(1, 1, "        GAME OVER", BANK_FONT, 0)

  GenEndGameBonusText()
  L2Text(1,4,"YOUR PUNISHMENT;", BANK_FONT, 0)
  L2Text(2, 6, gBonusText(1), BANK_FONT, 0)

  'for bon=1 to gBonusTextCount
  ''  L2Text(2, 6+bon, gBonusText(bon), BANK_FONT, 0)
  'next bon

 '' L2Text(0, 10, debugStr1, BANK_FONT, 0)
  'L2Text(0, 12, debugStr2, BANK_FONT, 0)

  L2Text(15, 22, "PRESS SPACE/FIRE", BANK_FONT, 0)
  
  gCurrentTrack=MUSIC_ENDGAME
  gNeedInit=2
end sub
