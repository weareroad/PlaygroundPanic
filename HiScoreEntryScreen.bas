sub HandleHiScoreEntryScreen()
  if gNeedInit=1 then InitHiScoreEntryScreen()
  UpdateHiScoreEntryScreen()
  ReadHiScoreEntryKeyboard()
  if gNeedInit=2 then ChangeMusic()
end sub


sub InitHiScoreEntryScreen()
  AllSpritesOff()
  PlayerSpriteOff()
  
  ''CLS256(COLOR_BACKGROUND)
  ClearLayer2(COLOR_BACKGROUND)

  L2Text(1, 1, "HIGH SCORE ENTRY", BANK_FONT, 0)
  L2Text(20, 22, "PRESS SPACE", BANK_FONT, 0)
  gNeedInit=0
end sub


sub UpdateHiScoreEntryScreen()
end sub


sub ReadHiScoreEntryKeyboard()
  dim key as UINTEGER
  key = GetKeyScanCode()
  if key=KEYSPACE
    Debounce(KEYSPACE)
    JumpScreen(GAMESCREEN)
  endif
end sub
