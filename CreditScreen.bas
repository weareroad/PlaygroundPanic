sub HandleCreditScreen()
  if gNeedInit=1 then InitCreditScreen()
  UpdateCreditScreen()
  ReadCreditKeyboard()
  if gNeedInit=2 ChangeMusic()
end sub

sub InitCreditScreen()
  ResetAttract()
  AllSpritesOff()
  PlayerSpriteOff()
  tSettings = 2000
 
  ''CLS256(COLOR_BACKGROUND)
  ClearLayer2(COLOR_BACKGROUND)

  L2Text(1, 1, "       PLAYGROUND PANIC", BANK_FONT, 0)
  L2Text(1, 3, " A SPECNEXT GAME, AS PROMISED", BANK_FONT, 0)
  L2Text(1, 6, "     THANKS AND GREETINGS", BANK_FONT, 0)
  L2Text(1 ,8, "JIM BAGLEY, -MANY- THANKS MATE", BANK_FONT, 0)
  L2Text(1 ,9, "DAVID EM00K SAPHIER, NEXTBUILD", BANK_FONT, 0)
  L2Text(1 ,10, "REMY SHARP,              TOOLS", BANK_FONT, 0)
  L2Text(1 ,11, "MATTHEW GUY,              HELP", BANK_FONT, 0)
  L2Text(1 ,12, "MIKE DAILLY,            CSPECT", BANK_FONT, 0)
  L2Text(1 ,14, "JOSE RODRIGUEZ,         BORIEL", BANK_FONT, 0)
  L2Text(1 ,16, "THE ENTIRE SPECTRUM NEXT TEAM!", BANK_FONT, 0)
  L2Text(1 ,18, "THE RETRO / SPECTRUM COMMUNITY", BANK_FONT, 0)
  L2Text(1 ,20, "YOU, FOR TAKING A LOOK AT THIS", BANK_FONT, 0)

  ''EnableMusic 
  ''EnableSFX

  dim clr as ubyte = pClr<<4
  SetupAttract(1, PLAYERSPRITEWALK+1, PLAYERHARDLEFT, 210, PLAYERHARDRIGHT, 210, 4, PLAYERANIMFRAMECOUNT, MOVE_RIGHT, clr, MOVING)

  L2Text(15, 22, "PRESS SPACE/FIRE", BANK_FONT, 0)
  gCurrentTrack = MUSIC_ATTRACT
  gNeedInit=2
end sub



sub UpdateCreditScreen()
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
    JumpScreen(ATTRACTSCREEN)
    return
  endif
  tSettings = tSettings - 1 

end sub

sub ReadCreditKeyboard()
  if SpaceOrFire()=1 then JumpScreen(SETTINGSSCREEN)
end sub

