sub SpawnMilk()
  cXPos(SPRITE_MILK)=GetClearXPos()
  cYPos(SPRITE_MILK)=GetClearYPos()
  cMode(SPRITE_MILK)=MODE_ACTIVE
  cKind(SPRITE_MILK)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub


sub SpawnDog()
  if gDogMode = 1 then return

  cXPos(SPRITE_DOG)=gExitX
  cYPos(SPRITE_DOG)=gExitY
  cTargetX(SPRITE_DOG)=GetClearXPos()
  cTargetY(SPRITE_DOG)=GetClearYPos()
  cMode(SPRITE_DOG)=MODE_ACTIVE
  cKind(SPRITE_DOG)=KIND_TARGET
  cPrivateTimer(SPRITE_DOG) = cast(UINTEGER,TIMER_TO_POO / 4)
  PlaySound(SOUND_NPC_APPEAR)
  gDogMode = 1
end sub


sub SpawnSnatcher()
  cXPos(SPRITE_SNATCHER)=gExitX
  cYPos(SPRITE_SNATCHER)=gExitY
  if cMode(SPRITE_MILK)=MODE_ACTIVE ' just in case we somehow launch without target milk
    cTargetX(SPRITE_SNATCHER)=cXPos(SPRITE_MILK)
    cTargetY(SPRITE_SNATCHER)=cYPos(SPRITE_MILK)
  else
    cTargetX(SPRITE_SNATCHER)=pXPos
    cTargetY(SPRITE_SNATCHER)=pYPos
  endif
  cMode(SPRITE_SNATCHER)=MODE_ACTIVE
  cKind(SPRITE_SNATCHER)=KIND_TARGET
  PlaySound(SOUND_NPC_APPEAR)
end sub


sub SpawnCane()
  cXPos(SPRITE_CANE)=GetClearXPos()
  cYPos(SPRITE_CANE)=GetClearYPos()
  cMode(SPRITE_CANE)=MODE_ACTIVE
  cKind(SPRITE_CANE)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
end sub


sub SpawnDust()
  cXPos(SPRITE_DUST)=GetClearXPos()
  cYPos(SPRITE_DUST)=GetClearYPos()
  cMode(SPRITE_DUST)=MODE_ACTIVE
  cKind(SPRITE_DUST)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
end sub

sub SetDinnerRoamTarget()
  cTargetX(SPRITE_DINNER) = GetClearXPos()
  cTargetY(SPRITE_DINNER) = GetClearYPos()
  SetForTarget(SPRITE_DINNER)
end sub

sub SpawnDinner()
' pick direction to move in
' pick direction to face
' this will give us our starting position
  cXPos(SPRITE_DINNER) = gExitX
  cYPos(SPRITE_DINNER) = gExitY

  cMode(SPRITE_DINNER) = MODE_ACTIVE
  cKind(SPRITE_DINNER) = KIND_WATCHER
''  cKind(SPRITE_DINNER)=KIND_TARGET 'KIND_WATCHER
  cSpeed(SPRITE_DINNER) = 5
  cTimer(SPRITE_DINNER) = 0
  cAnimFrame(SPRITE_DINNER) = 1
  cFrozen(SPRITE_DINNER) = 0

  gDinnerPlayerSeen = 0
  SetDinnerRoamTarget()
  PlaySound(SOUND_NPC_APPEAR)
end sub


' can we spawn something - keeping it all deterministic
sub SpawnSpecial()
  if gTimeToGo < 7 then return ' don't spawn anything if there's only a few seconds to go 

  dim active as ubyte = 0
  for n=SPRITE_DUST to SPRITE_COUNT
    if cMode(n)=MODE_ACTIVE then active = active + 1
  next n

  if active>=MAX_ACTIVE_SPECIALS then return

  ' bit ghastly but makes it deterministic without being a simple short cycle
  if gNextSpecial > 11 then gNextSpecial = 0

  if gNextSpecial = 0 or gNextSpecial = 9
    if cMode(SPRITE_MILK) = MODE_INACTIVE and cMode(SPRITE_SNATCHER) = MODE_INACTIVE then SpawnMilk()

  elseif gNextSpecial = 1 or gNextSpecial = 10 
    if cMode(SPRITE_SNATCHER) = MODE_INACTIVE and cMode(SPRITE_MILK) > MODE_INACTIVE then SpawnSnatcher()

  elseif gNextSpecial = 2 or gNextSpecial = 6 
    if cMode(SPRITE_CANE) = MODE_INACTIVE then SpawnCane()

  elseif gNextSpecial = 3 or gNextSpecial = 8
    if cMode(SPRITE_DOG) = MODE_INACTIVE then SpawnDog()

  elseif gNextSpecial = 4 or gNextSpecial = 7
    if cMode(SPRITE_DUST) = MODE_INACTIVE then SpawnDust()

  elseif gNextSpecial = 5 or gNextSpecial = 11
    if cMode(SPRITE_DINNER)=MODE_INACTIVE then SpawnDinner()

  endif
  
  gNextSpecial = gNextSpecial + 1
end sub




sub SpawnPoo()
  if gCurrentPoo >= POO_COUNT then return
  gCurrentPoo = gCurrentPoo + 1
  cPooXPos(gCurrentPoo) = cXPos(SPRITE_DOG)
  cPooYPos(gCurrentPoo) = cYPos(SPRITE_DOG)
  cPooMode(gCurrentPoo) = 1
  cPooTimer(gCurrentPoo) = POO_EXPIRY_TIMER
end sub



sub UpdateDog()
  if cDir(SPRITE_DOG) = MOVE_RIGHT
    UpdateSprite(cXPos(SPRITE_DOG), cYPos(SPRITE_DOG), SPRITE_DOG, DOGSPRITEWALK -1 + cAnimFrame(SPRITE_DOG), 0 , 0)
  elseif cDir(SPRITE_DOG) = MOVE_LEFT
    UpdateSprite(cXPos(SPRITE_DOG), cYPos(SPRITE_DOG), SPRITE_DOG, DOGSPRITEWALK -1 + cAnimFrame(SPRITE_DOG), 8 , 0)
  elseif cDir(SPRITE_DOG) = MOVE_UP 
    UpdateSprite(cXPos(SPRITE_DOG), cYPos(SPRITE_DOG), SPRITE_DOG, DOGSPRITECLIMBUP -1 + cAnimFrame(SPRITE_DOG),0 , 0)
  elseif cDir(SPRITE_DOG) = MOVE_DOWN
    UpdateSprite(cXPos(SPRITE_DOG), cYPos(SPRITE_DOG), SPRITE_DOG, DOGSPRITECLIMBDOWN -1 + cAnimFrame(SPRITE_DOG), 0 , 0)
   endif

  cPrivateTimer(SPRITE_DOG) = cPrivateTimer(SPRITE_DOG) - 1
  if cPrivateTimer(SPRITE_DOG) = 0
    cPrivateTimer(SPRITE_DOG) = TIMER_TO_POO
    SpawnPoo()
  endif

end sub


sub UpdateDinner()
  if cDir(SPRITE_DINNER) = MOVE_RIGHT
    UpdateSprite(cXPos(SPRITE_DINNER), cYPos(SPRITE_DINNER), SPRITE_DINNER, DINNERSPRITEWALK -1 + cAnimFrame(SPRITE_DINNER), 0 , 0)
  elseif cDir(SPRITE_DINNER) = MOVE_LEFT
    UpdateSprite(cXPos(SPRITE_DINNER), cYPos(SPRITE_DINNER), SPRITE_DINNER, DINNERSPRITEWALK -1 + cAnimFrame(SPRITE_DINNER), 8 , 0)
  elseif cDir(SPRITE_DINNER) = MOVE_UP 
    UpdateSprite(cXPos(SPRITE_DINNER), cYPos(SPRITE_DINNER), SPRITE_DINNER, DINNERSPRITECLIMBUP -1 + cAnimFrame(SPRITE_DINNER),0 , 0)
  elseif cDir(SPRITE_DINNER) = MOVE_DOWN
    UpdateSprite(cXPos(SPRITE_DINNER), cYPos(SPRITE_DINNER), SPRITE_DINNER, DINNERSPRITECLIMBDOWN -1 + cAnimFrame(SPRITE_DINNER), 0 , 0)
  endif
end sub


sub UpdateSnatcher()
  if cDir(SPRITE_SNATCHER) = MOVE_RIGHT
    UpdateSprite(cXPos(SPRITE_SNATCHER), cYPos(SPRITE_SNATCHER), SPRITE_SNATCHER, SNATCHERSPRITEWALK -1 + cAnimFrame(SPRITE_SNATCHER), 0 , 0)
  elseif cDir(SPRITE_SNATCHER) = MOVE_LEFT
    UpdateSprite(cXPos(SPRITE_SNATCHER), cYPos(SPRITE_SNATCHER), SPRITE_SNATCHER, SNATCHERSPRITEWALK -1 + cAnimFrame(SPRITE_SNATCHER), 8 , 0)
  elseif cDir(SPRITE_SNATCHER) = MOVE_UP 
    UpdateSprite(cXPos(SPRITE_SNATCHER), cYPos(SPRITE_SNATCHER), SPRITE_SNATCHER, SNATCHERSPRITECLIMBUP -1 + cAnimFrame(SPRITE_SNATCHER),0 , 0)
  elseif cDir(SPRITE_SNATCHER) = MOVE_DOWN
    UpdateSprite(cXPos(SPRITE_SNATCHER), cYPos(SPRITE_SNATCHER), SPRITE_SNATCHER, SNATCHERSPRITECLIMBDOWN -1 + cAnimFrame(SPRITE_SNATCHER), 0 , 0)
  endif
end sub


sub UpdateMilk()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_MILK), cYPos(SPRITE_MILK), SPRITE_MILK, MILKSPRITE, clr , 0)
end sub


sub UpdateCane()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_CANE), cYPos(SPRITE_CANE), SPRITE_CANE, CANESPRITE, clr , 0)
end sub 


sub UpdateDust()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_DUST), cYPos(SPRITE_DUST), SPRITE_DUST, DUSTSPRITE, clr , 0)
end sub


sub CollideSnatcherMilk()
  cMode(SPRITE_MILK) = MODE_INACTIVE
  PlaySound(SOUND_GOT_MILK)
  IncreaseTime(MILK_TIME)
  UpdateTime()
  RemoveSprite(SPRITE_MILK,0)
  SignalLeave(SPRITE_SNATCHER)
end sub


sub CollideMilk()
  cMode(SPRITE_MILK) = MODE_INACTIVE
  PlaySound(SOUND_GOT_MILK)
  ReduceTime(MILK_TIME)
  UpdateTime()
  RemoveSprite(SPRITE_MILK,0)
end sub


sub CollideDust()
  cMode(SPRITE_DUST) = MODE_INACTIVE
  PlaySound(SOUND_GOT_DUST)
  FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_DUST,0)
end sub


sub CollideCane()
  cMode(SPRITE_CANE) = MODE_INACTIVE
  PlaySound(SOUND_GOT_CANE)
  FreezePlayer(CANE_FREEZE)
  IncreaseTime(CANE_TIME)
  UpdateTime()
  RemoveSprite(SPRITE_CANE, 0)
end sub


sub CollideDinner()
  FreezePlayer(DINNER_FREEZE)
  PlaySound(SOUND_OUCH)
end sub


sub CollideSnatcher()
  FreezePlayer(SNATCHER_FREEZE)
  PlaySound(SOUND_OUCH)
  UpdateTime()
  SnatcherOut()
end sub


sub CollideDog()
  FreezePlayer(DOG_FREEZE)
  PlaySound(SOUND_OUCH)
  DogOut()
end sub


sub DinnerOut()
  if cMode(SPRITE_DINNER) > MODE_INACTIVE
    cKind(SPRITE_DINNER) = KIND_GO_EXIT
    HandleNPCChange(SPRITE_DINNER)
  endif
  gDinnerPlayerSeen = 0
end sub


sub DogOut()
  if cMode(SPRITE_DOG) > MODE_INACTIVE
    cKind(SPRITE_DOG) = KIND_GO_EXIT
    HandleNPCChange(SPRITE_DOG)
  endif
end sub


sub SnatcherOut()
  if cMode(SPRITE_SNATCHER) > MODE_INACTIVE
    cKind(SPRITE_SNATCHER) = KIND_GO_EXIT
    HandleNPCChange(SPRITE_SNATCHER)
  endif
end sub


' flip all remaining active NPCs to head for the exit
sub EverybodyOut()
  for npc = 1 to SPRITE_NPC_COUNT
    if cMode(npc) > MODE_INACTIVE
      cKind(npc) = KIND_GO_EXIT
      HandleNPCChange(npc)
    endif
  next npc
  DinnerOut()
  DogOut()
  SnatcherOut()
end sub


function DinnerCanSeePlayer() as ubyte
  if cMode(SPRITE_DINNER) <> MODE_ACTIVE then return 0
  if gTimeToGo = 0 then return 0
  if cKind(SPRITE_DINNER) = KIND_GO_EXIT then return 0
  if CheckPlayerNPCCollision(SPRITE_DINNER) = COLLISION then return 0

  dim dx as INTEGER
  dim dy as INTEGER

  dx = abs(tInts(pXPos) - tInts(cXPos(SPRITE_DINNER)))
  dy = abs(tInts(pYPos) - tInts(cYPos(SPRITE_DINNER)))

  if cDir(SPRITE_DINNER) = MOVE_DOWN
    if dx <= DINNER_SIGHT_MARGIN and _
       dy <= DINNER_SIGHT_DISTANCE and _
       pYPos > cYPos(SPRITE_DINNER) then return 1

  elseif cDir(SPRITE_DINNER) = MOVE_UP
    if dx <= DINNER_SIGHT_MARGIN and _
      dy <= DINNER_SIGHT_DISTANCE and _
      pYPos < cYPos(SPRITE_DINNER) then return 1

  elseif cDir(SPRITE_DINNER) = MOVE_RIGHT
    if dy <= DINNER_SIGHT_MARGIN and _
      dx <= DINNER_SIGHT_DISTANCE and _
      pXPos > cXPos(SPRITE_DINNER) then return 1

  elseif cDir(SPRITE_DINNER) = MOVE_LEFT
    if dy <= DINNER_SIGHT_MARGIN and _
      dx <= DINNER_SIGHT_DISTANCE and _
      pXPos < cXPos(SPRITE_DINNER) then return 1
  endif

  return 0
end function


sub HandleDinnerSight()
  dim canSee as ubyte = DinnerCanSeePlayer()

  if canSee = 0
    gDinnerPlayerSeen = 0
    return
  endif

  if gDinnerPlayerSeen = 0
    gDinnerPlayerSeen = 1
    IncreaseTime(MILK_TIME)
    UpdateTime()
    PlaySound(SOUND_SEEN)
  endif
end sub