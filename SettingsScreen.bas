sub HandleSettingsScreen()
  if gNeedInit=1 then InitSettingsScreen()
  UpdateSettingsItems()
  ReadSettingsKeyboard()
  if gNeedInit=2 then ChangeMusic()
 
end sub


sub InitSettingsScreen()
  ResetAttract()
  AllSpritesOff()
  PlayerSpriteOff()

 '' RefreshSettings()
  tSettings=SETTINGSTIMERWAIT
  ySettingsGame = 4 ' always reset this'
  ySettingsHighlight = 4

  CLS256(COLOR_BACKGROUND)
  dim mask as ubyte = 0

  L2Text(7, 1, "PLAYGROUND PANIC", BANK_FONT ,mask)

  L2Text(1, 4, "START GAME", BANK_FONT, mask)

  L2Text(1, 7, "KEYS", BANK_FONT, mask)
  L2Text(1, 11, "SCHOOL SIZE", BANK_FONT, mask)
  L2Text(1, 15, "SEGREGATION", BANK_FONT, mask)

  L2Text(15, 4, "NEW GAME", BANK_FONT, mask)
  
  L2Text(15, 7, "KEMPSTON STICK", BANK_FONT, mask)
  L2Text(15, 8, gKeyUp+", "+gKeyDown+", "+gKeyLeft+", "+gKeyRight+" & "+gKeyAbort, BANK_FONT, mask)
  L2Text(15, 9, "CHANGE KEYS", BANK_FONT, mask)

  L2Text(15, 11, "RURAL", BANK_FONT, mask)
  L2Text(15, 12, "SUBURBAN", BANK_FONT, mask)
  L2Text(15, 13, "METROPOLITAN", BANK_FONT, mask)

  L2Text(15, 15, "FIRST YEARS ONLY", BANK_FONT, mask)
  L2Text(15, 16, "LOWER HALF", BANK_FONT, mask)
  L2Text(15, 17, "MIXED", BANK_FONT, mask)
  L2Text(15, 18, "UPPER HALF", BANK_FONT, mask)
  L2Text(15, 19, "NO GIRLS ALLOWED", BANK_FONT, mask)

  L2Text(15, 21, "RESET SPECTRUM", BANK_FONT, mask)

  RefreshSettings()
  gCurrentTrack = MUSIC_ATTRACT
  gNeedInit=2
end sub


sub RefreshSettings()
  ' blank out the section where the indicators and selected item are...
  for n = 4 to 21
    DoTileBank8(13, n, TILE_GREEN_BACKGROUND, BANK_TILES)
    DoTileBank8(14, n, TILE_GREEN_BACKGROUND, BANK_TILES)
  next n

  ' indicate the line we're looking at  
  DoTileBank8(13, ySettingsHighlight, TILE_SETTING_HIGHLIGHT, BANK_TILES)

  ' indicate our various selected options
  DoTileBank8(14, 11+ySettingsSchool, TILE_SETTING_SELECTED, BANK_TILES)
  DoTileBank8(14, 15+ySettingsSegregation, TILE_SETTING_SELECTED, BANK_TILES)
end sub


' reign-in the y position based on the screen content, going upwards
sub UpSettings()
  if ySettingsHighlight = 4
    ySettingsHighlight = 21
  elseif ySettingsHighlight = 9
    ySettingsHighlight = 4
  elseif ySettingsHighlight = 11
    ySettingsHighlight = 9
  elseif ySettingsHighlight = 15
    ySettingsHighlight = 13
  elseif ySettingsHighlight = 21
    ySettingsHighlight = 19
  else
    ySettingsHighlight = ySettingsHighlight - 1
  endif
  RefreshSettings()  
end sub


' reign-in the y position based on the screen content, going downards
sub DownSettings()
  if ySettingsHighlight = 4
    ySettingsHighlight = 9
  elseif ySettingsHighlight = 9
    ySettingsHighlight = 11
  elseif ySettingsHighlight = 13
    ySettingsHighlight = 15
  elseif ySettingsHighlight = 19
    ySettingsHighlight = 21
  elseif ySettingsHighlight = 21
    ySettingsHighlight = 4
  else
    ySettingsHighlight = ySettingsHighlight + 1 
  endif
  RefreshSettings()  
end sub


' user press select
sub SelectSettings()

  if ySettingsHighlight = 4 'play game
    gLevel=1
    GameInit()
    JumpScreen(LEVELSTARTSCREEN)
    return
   
  elseif ySettingsHighlight = 9 ' change keys
    JumpScreen(KEYSSCREEN)
    ySettingsHighlight = 4
    return

  elseif ySettingsHighlight = 11 ' rural school
    ySettingsSchool = 0
  elseif ySettingsHighlight = 12 ' suburban school
    ySettingsSchool = 1
  elseif ySettingsHighlight = 13 ' metropolitan school
    ySettingsSchool = 2

  elseif ySettingsHighlight > 14 and ySettingsHighlight < 20
    ySettingsSegregation = ySettingsHighlight - 15 ' setting segregation
  
  elseif ySettingsHighlight = 21
    ResetNext()

endif

  RefreshSettings()  
end sub


sub ReadSettingsKeyboard()
  dim key as UINTEGER
  dim joy as byte

  key = GetKeyScanCode()
  if key <> 0
    Debounce(key)
  endif

  joy = in(31)
  if joy <> 0
    do until in(31)=0 : loop
  endif

  if key = KEY_UP or  key = KEY7 or (joy bAnd JOY_UP = JOY_UP) 
    tSettings = SETTINGSTIMERWAIT
    UpSettings()
  elseif key = KEY_DOWN or key = KEY6 or (joy bAnd JOY_DOWN = JOY_DOWN)
    tSettings = SETTINGSTIMERWAIT
    DownSettings()
  elseif key = KEYSPACE or key = KEY0 or key = KEY_LEFT or key=KEY_RIGHT or (joy bAnd JOY_LEFT = JOY_LEFT) or (joy bAnd JOY_RIGHT = JOY_RIGHT)
    tSettings=SETTINGSTIMERWAIT
    SelectSettings()
  endif

end sub


sub UpdateSettingsItems()
  if tSettings = 0 '  time to move on?
    JumpScreen(ATTRACTSCREEN)
    return
  endif
  tSettings = tSettings - 1  
end sub
