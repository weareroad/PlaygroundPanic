sub HandleLoreScreen()
  if gNeedInit=1 then InitLoreScreen()
  UpdateLoreScreen()
  ReadLoreKeyboard()
  if gNeedInit=2 then ChangeMusic()
end sub


' lots of hard-coded nonsense, it's just a 'lore' screen, don't be too concerned about magic numbers

sub SetupLoreDog(yofs as ubyte)
  SetupAttract(1, DOGSPRITEWALK, PLAYERHARDLEFT, yofs, PLAYERHARDLEFT + (8*13), yofs, 5, NPCANIMFRAMECOUNT, MOVE_RIGHT, 0,  NOT_MOVING)
end sub


sub SetupLorePlayer(yofs as ubyte)
  dim clr as ubyte = pClr<<4
  SetupAttract(2, PLAYERSPRITEWALK+1, PLAYERHARDRIGHT, yofs, PLAYERHARDRIGHT - (8 * 11), yofs, 4, PLAYERANIMFRAMECOUNT, MOVE_LEFT, 8+clr, NOT_MOVING)
end sub


sub SetupLoreSnatcher(yofs as ubyte)
  SetupAttract(3, SNATCHERSPRITEWALK, PLAYERHARDLEFT, yofs, PLAYERHARDLEFT + (8 * 16), yofs, 4, NPCANIMFRAMECOUNT, MOVE_RIGHT, 0, NOT_MOVING)
end sub


sub SetupLoreDinner(yofs as ubyte)
  SetupAttract(4, DINNERSPRITEWALK, PLAYERHARDLEFT, yofs, PLAYERHARDLEFT + (8 * 14), yofs, 4, NPCANIMFRAMECOUNT, MOVE_RIGHT, 0, NOT_MOVING)
end sub


sub SetupLoreNPC(yofs as ubyte)
  SetupAttract(5, PLAYERSPRITEWALK+1, PLAYERHARDLEFT, yofs, PLAYERHARDLEFT + (8 * 13), yofs, 4, NPCANIMFRAMECOUNT, MOVE_RIGHT, 0, NOT_MOVING)
end sub


sub SetupLoreMilk(yofs as ubyte)
  SetupAttract(6, MILKSPRITE, PLAYERHARDRIGHT, yofs, PLAYERHARDRIGHT, yofs, 1, 1, MOVE_RIGHT, 0, NOT_MOVING)
end sub


sub SetupLoreSpaceDust(yofs as ubyte)
  SetupAttract(7, DUSTSPRITE, PLAYERHARDRIGHT, yofs, PLAYERHARDRIGHT, yofs, 1, 1, MOVE_RIGHT, 0, NOT_MOVING)
end sub


sub SetupLoreCane(yofs as ubyte)
  SetupAttract(8, CANESPRITE, PLAYERHARDLEFT, yofs, PLAYERHARDLEFT, yofs, 1, 1, MOVE_RIGHT, 0, NOT_MOVING)
end sub


sub SetupLorePoo(yofs as ubyte)
  SetupAttract(9, POOSPRITE, PLAYERHARDLEFT, yofs, PLAYERHARDLEFT, yofs, 1, 1, MOVE_RIGHT, 0, NOT_MOVING)
end sub


sub SetupLoreNPCs()
  for att=1 to ATTRACT_COUNT
    atMode(att) = MODE_INACTIVE
  next att

  dim yofs as ubyte = PLAYERHARDTOP + 26
  SetupLoreDog(yofs)
  yofs=yofs+26
  SetupLoreSnatcher(yofs)
  yofs=yofs+24
  SetupLoreDinner(yofs)
  yofs=yofs+24
  SetupLoreNPC(yofs)
  yofs=yofs+24
  SetupLoreCane(yofs)
  yofs=yofs+24
  SetupLorePoo(yofs)

  yofs = PLAYERHARDTOP + 28
  SetupLorePlayer(yofs)
  yofs=yofs+24
  SetupLoreMilk(yofs)
  yofs=yofs+24
  SetupLoreSpaceDust(yofs) 
end sub


sub InitLoreScreen()
  ResetAttract()
  AllSpritesOff()
  PlayerSpriteOff()
  tSettings = 1300

  CLS256(COLOR_BACKGROUND)
  L2Text(1, 1, "     INTRODUCING THE CAST", BANK_FONT, 0)
  L2Text(15, 22, "PRESS SPACE/FIRE", BANK_FONT, 0)
  SetupLoreNPCs()

  L2Text(21, 5, "OUR HERO", BANK_FONT, 0)
  L2Text(25, 8, "MILK", BANK_FONT, 0)
  L2Text(20, 11, "SPACEDUST", BANK_FONT, 0)

  L2Text(3, 5, "RANDOM DOG", BANK_FONT, 0)
  L2Text(3, 8, "MILK SNATCHER", BANK_FONT, 0)
  L2Text(3, 11, "DINNER LADY", BANK_FONT, 0)
  L2Text(3, 14, "RANDOM KID", BANK_FONT, 0)
  L2Text(3, 17, "CANE", BANK_FONT, 0)
  L2Text(3, 20, "POO", BANK_FONT, 0)

  gNeedInit=0
end sub


sub UpdateLoreScreen()
  UpdateAttractSprites()
  ' now screen specific stuff'
  if tSettings = 900
    for att=1 to ATTRACT_COUNT
      if atMode(att) = MODE_ACTIVE 
        if atTargetX(att)<>atXPos(att) or atTargetY(att)<>atYPos(att)
          atMove(att)=MOVING
          atFrame(att)=0
          atTimer(att)=atSpeed(att)
        endif
      endif
    next att
  elseif tSettings = 0 '  time to move on?
    JumpScreen(CREDITSCREEN)
    return
  endif
  tSettings = tSettings - 1 
end sub


sub ReadLoreKeyboard()
if SpaceOrFire()=1 then JumpScreen(SETTINGSSCREEN)

'dim key as UINTEGER
''  key = GetKeyScanCode()
''  if key=KEYSPACE
''    Debounce(KEYSPACE)
''    JumpScreen(CREDITSCREEN)
''  endif
end sub

