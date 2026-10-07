sub HandleAttractScreen()
  if gNeedInit=1 then InitAttractScreen()

  UpdateAttractScreen()
  ReadAttractKeyboard()

  if gNeedInit=2 ChangeMusic()
end sub


sub InitAttractScreen()
  ResetAttract()
  AllSpritesOff()
  PlayerSpriteOff()
  tSettings = 2000

  CLS256(COLOR_BACKGROUND)
  L2Text(1, 1, "      PLAYGROUND PANIC!", BANK_FONT, 0)
  L2Text(1, 3, "   FROM ROAD SOFTWARE 2026", BANK_FONT, 0)

  L2Text(1,7, "  AVOID THE OTHER KIDS UNTIL", BANK_FONT, 0)
  L2Text(1,8, "       BREAK-TIME ENDS.", BANK_FONT, 0)
  L2Text(1,10, "SOME THINGS HELP PASS THE TIME", BANK_FONT, 0)
  L2Text(1,11, "  AND SOME JUST MAKE IT WORSE.", BANK_FONT, 0)
  L2Text(1,13, "DONT LET THE DINNER LADY CATCH", BANK_FONT, 0)
  L2Text(1,14, "        YOU RUNNING...", BANK_FONT, 0)
  L2Text(1,16, " AND STAY OUT OF THE DOG POO!", BANK_FONT, 0)

  dim clr as ubyte = pClr<<4
  SetupAttract(1, PLAYERSPRITEWALK+1, PLAYERHARDLEFT, 210, PLAYERHARDRIGHT, 210, 4, PLAYERANIMFRAMECOUNT, MOVE_RIGHT, clr, MOVING)
  
  L2Text(1,22, GAME_VER, BANK_FONT, 0)

  L2Text(15, 22, "PRESS SPACE/FIRE", BANK_FONT, 0)

  gCurrentTrack = MUSIC_ATTRACT
  gNeedInit=2
end sub


sub UpdateAttractScreen()
  UpdateAttractSprites()
  dim spr as ubyte = 1

  ' now screen specific stuff'
  if atMode(spr)=MODE_ACTIVE and atMove(spr)=MOVING
    if atXPos(spr)=atTargetX(spr) and atYPos(spr)=atTargetY(spr)
      FlipAttractSprite(spr)
    endif
  endif

  if tSettings = 900
    for att=1 to ATTRACT_COUNT
      if atMode(att) = MODE_ACTIVE 
        if atTargetX(att)<>atXPos(att) or atTargetY(att)<>atYPos(att) then atMove(att)=MOVING
      endif
    next att
  elseif tSettings = 0 '  time to move on?
    JumpScreen(LORESCREEN)
    return
  endif
  tSettings = tSettings - 1 
end sub


sub ReadAttractKeyboard()
  if SpaceOrFire()=1 then JumpScreen(SETTINGSSCREEN)
end sub

