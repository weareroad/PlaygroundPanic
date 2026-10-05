sub HandleKeysScreen()
  if gNeedInit=1 then InitKeysScreen()

  UpdateKeysScreen()
  ReadKeysKeyboard()
  if gNeedInit=2 then ChangeMusic()
end sub

sub InitKeysScreen()
  AllSpritesOff()
  PlayerSpriteOff()
  
  CLS256(COLOR_BACKGROUND)
  L2Text(1, 1, "    REDEFINE KEYS", BANK_FONT, 0)
  gNeedInit=0

  gKeyStep=0
end sub

sub UpdateKeysScreen()
  if gKeyStep=0
    L2Text(2,4,"PRESS THE KEY FOR UP", BANK_FONT, 0)
  else  if gKeyStep=1
    L2Text(2,6,"PRESS THE KEY FOR DOWN", BANK_FONT, 0)
  else if gKeyStep=2
    L2Text(2,8,"PRESS THE KEY FOR LEFT", BANK_FONT, 0)
  else if gKeyStep=3
    L2Text(2,10,"PRESS THE KEY FOR RIGHT", BANK_FONT, 0)
  else if gKeyStep=4
    L2Text(2,12,"PRESS THE KEY FOR ABORT", BANK_FONT, 0)
  else
    L2Text(15, 22, "PRESS SPACE/FIRE", BANK_FONT, 0)
  endif
end sub

sub ReadKeysKeyboard()
  if gKeyStep>4
    if SpaceOrFire()=1 then JumpScreen(SETTINGSSCREEN)
    return
  endif

  dim key as UINTEGER
  key = GetKeyScanCode()
  if key=0 then return

  do until GetKeyScanCode()=0 : loop
  dim sKey as string = ScanCodeToString(key)
  dim cooked as UINTEGER = cast(UINTEGER, key)
  if gKeyStep=0
    if key=KEYSPACE then return
    KEY_UP = key 'cooked
    gKeyUp = sKey
    L2Text(27,4,gKeyUp, BANK_FONT, 0)
  else if gKeyStep=1
    if key=KEYSPACE or key=KEY_UP then return
    KEY_DOWN = key 'cooked
    gKeyDown = sKey
    L2Text(27,6,gKeyDown, BANK_FONT, 0)
  else if gKeyStep=2
    if key=KEYSPACE or key=KEY_UP or key=KEY_DOWN then return
    KEY_LEFT = key 'cooked
    gKeyLeft = sKey
    L2Text(27,8,gKeyLeft, BANK_FONT, 0)
  else if gKeyStep=3
    if key=KEYSPACE or key=KEY_UP or key=KEY_DOWN or key=KEY_LEFT then return
    KEY_RIGHT = key 'cooked
    gKeyRight = sKey
    L2Text(27,10,gKeyRight, BANK_FONT, 0)
  else if gKeyStep=4
    if key=KEYSPACE or key=KEY_UP or key=KEY_DOWN or key=KEY_LEFT or key=KEY_RIGHT then return
    KEY_ABORT = key 'cooked
    gKeyAbort = sKey
    L2Text(27,12,gKeyAbort, BANK_FONT, 0)
  endif

  gKeyStep=gKeyStep+1

end sub

