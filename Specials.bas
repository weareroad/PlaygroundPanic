sub SpawnMilk()
  cXPos(SPRITE_MILK)=GetClearXPos()
  cYPos(SPRITE_MILK)=GetClearYPos()
  cMode(SPRITE_MILK)=MODE_ACTIVE
  cKind(SPRITE_MILK)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnBell()
  cXPos(SPRITE_BELL)=GetClearXPos()
  cYPos(SPRITE_BELL)=GetClearYPos()
  cMode(SPRITE_BELL)=MODE_ACTIVE
  cKind(SPRITE_BELL)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnSprite1()
  cXPos(SPRITE_1)=GetClearXPos()
  cYPos(SPRITE_1)=GetClearYPos()
  cMode(SPRITE_1)=MODE_ACTIVE
  cKind(SPRITE_1)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnSprite2()
  cXPos(SPRITE_2)=GetClearXPos()
  cYPos(SPRITE_2)=GetClearYPos()
  cMode(SPRITE_2)=MODE_ACTIVE
  cKind(SPRITE_2)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnSprite3()
  cXPos(SPRITE_3)=GetClearXPos()
  cYPos(SPRITE_3)=GetClearYPos()
  cMode(SPRITE_3)=MODE_ACTIVE
  cKind(SPRITE_3)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnSprite4()
  cXPos(SPRITE_4)=GetClearXPos()
  cYPos(SPRITE_4)=GetClearYPos()
  cMode(SPRITE_4)=MODE_ACTIVE
  cKind(SPRITE_4)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnSprite5()
  cXPos(SPRITE_5)=GetClearXPos()
  cYPos(SPRITE_5)=GetClearYPos()
  cMode(SPRITE_5)=MODE_ACTIVE
  cKind(SPRITE_5)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnSprite6()
  cXPos(SPRITE_6)=GetClearXPos()
  cYPos(SPRITE_6)=GetClearYPos()
  cMode(SPRITE_6)=MODE_ACTIVE
  cKind(SPRITE_6)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnSprite7()
  cXPos(SPRITE_7)=GetClearXPos()
  cYPos(SPRITE_7)=GetClearYPos()
  cMode(SPRITE_7)=MODE_ACTIVE
  cKind(SPRITE_7)=KIND_STATIC
  PlaySound(SOUND_ITEM_APPEAR)
  gTimeNextSpecial = gTimeBetweenSpecials / 2 
end sub

sub SpawnSprite8()
  cXPos(SPRITE_8)=GetClearXPos()
  cYPos(SPRITE_8)=GetClearYPos()
  cMode(SPRITE_8)=MODE_ACTIVE
  cKind(SPRITE_8)=KIND_STATIC
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
  for n=SPRITE_STATIC_START to SPRITE_COUNT
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

      '' add other ones in here
      '' and fix how we loop through these
      '' ideally a loop for the dog, dinner lady, snatcher, milk
      '' and a separate loop for all the others
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

sub UpdateBell()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_BELL), cYPos(SPRITE_BELL), SPRITE_BELL,BELLSPRITE, clr , 0)
end sub


sub UpdateSprite1()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_1), cYPos(SPRITE_1), SPRITE_1, NEW01SPRITE, clr , 0)
end sub
sub UpdateSprite2()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_2), cYPos(SPRITE_2), SPRITE_2, NEW02SPRITE, clr , 0)
end sub
sub UpdateSprite3()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_3), cYPos(SPRITE_3), SPRITE_3, NEW03SPRITE, clr , 0)
end sub
sub UpdateSprite4()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_4), cYPos(SPRITE_4), SPRITE_4, NEW04SPRITE, clr , 0)
end sub
sub UpdateSprite5()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_5), cYPos(SPRITE_5), SPRITE_5, NEW05SPRITE, clr , 0)
end sub
sub UpdateSprite6()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_6), cYPos(SPRITE_6), SPRITE_6, NEW06SPRITE, clr , 0)
end sub
sub UpdateSprite7()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_7), cYPos(SPRITE_7), SPRITE_7, NEW07SPRITE, clr , 0)
end sub
sub UpdateSprite8()
  dim clr as ubyte = 0
  UpdateSprite(cXPos(SPRITE_8), cYPos(SPRITE_8), SPRITE_8, NEW08SPRITE, clr , 0)
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

sub CollideSprite1()
  cMode(SPRITE_1) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  IncreaseTime(5)
  ''FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_1,0)
end sub

sub CollideSprite2()
  cMode(SPRITE_2) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  ''FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_2,0)
end sub

sub CollideSprite3()
  cMode(SPRITE_3) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  ''FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_3,0)
end sub

sub CollideSprite4()
  cMode(SPRITE_4) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  ''FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_4,0)
end sub

sub CollideSprite5()
  cMode(SPRITE_5) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  ''FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_5,0)
end sub

sub CollideSprite6()
  cMode(SPRITE_6) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  ''FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_6,0)
end sub

sub CollideSprite7()
  cMode(SPRITE_7) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  ''FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_7,0)
end sub

sub CollideSprite8()
  cMode(SPRITE_8) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  ''FreezeNPCs(DUST_FREEZE)
  RemoveSprite(SPRITE_8,0)
end sub

sub CollideBell()
  cMode(SPRITE_BELL) = MODE_INACTIVE
  PlaySound(SOUND_OUCH)
  ''FreezeNPCs(DUST_FREEZE)
  ReduceTime(MILK_TIME)
  RemoveSprite(SPRITE_BELL,0)
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