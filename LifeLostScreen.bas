sub HandleLifeLostScreen()
  if gNeedInit=1 then InitLifeLostScreen()

  UpdateLifeLostScreen()
  ReadLifeLostKeyboard()

  if gNeedInit=2 then ChangeMusic()

end sub


sub InitLifeLostScreen()
  AllSpritesOff()
  
  CLS256(COLOR_BACKGROUND)
  L2Text(1, 1, "     YOU GOT TOUCHED!", BANK_FONT, 0)
  GenEndLifeBonusText()
  L2Text(1,4, "      YOUR BOOBY-PRIZE;", BANK_FONT, 0)
  L2Text(2, 6, gBonusText(1), BANK_FONT, 0)
  
  if gLives>1
    L2Text(5,16,"YOU HAVE "+str(gLives)+" LIVES LEFT", BANK_FONT, 0)
  else
    L2Text(2,16,"LAST LIFE! PLAYGROUND PANIC!!", BANK_FONT, 0)
  endif  
  L2Text(3, 20, "PRESS SPACE/FIRE TO CONTINUE", BANK_FONT, 0)
  gNeedInit=0
end sub


sub UpdateLifeLostScreen()
end sub


sub ReadLifeLostKeyboard()
  dim key as UINTEGER = GetKeyScanCode()
  if key=KEYSPACE
    Debounce(KEYSPACE)
    JumpScreen(GAMESCREEN)
  elseif key=KEY_ABORT
    Debounce(KEY_ABORT)
    JumpScreen(GAMEOVERSCREEN)
  endif
end sub

