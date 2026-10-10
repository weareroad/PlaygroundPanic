sub HandleGameScreen()
  if gNeedInit=1 then InitGameScreen(gLevel)

  ReadGameKeyboard()
  UpdateGamePlayer()
  UpdateGameItems()

  if gNeedInit=2 then ChangeMusic()

  if endGame=1
    LifeOver()
  elseif endGame=2
    ' we're done, the level is finished
    NextLevel()
  endif
end sub


sub InitLevelDirection(tDir as uByte)
  gDoorTop = TILE_LEFT_DOOR_TOP
  gDoorBottom = TILE_LEFT_DOOR_BOTTOM
  gDoorOpen = TILE_LEFT_DOOR_OPEN

  if tDir = MOVE_LEFT
    gExitX = PLAYERHARDLEFT
    gExitY = PLAYERHARDTOP
    gTileXExit = TILE_LEFT_OOB
    gTileYExit = TILE_TOP_IB
 
  elseif tDir = MOVE_RIGHT
    gExitX = PLAYERHARDRIGHT
    gExitY = PLAYERHARDBOTTOM
    gTileXExit = TILE_RIGHT_OOB
    gTileYExit = TILE_BOTTOM_IB-1
    gDoorTop = TILE_RIGHT_DOOR_TOP
    gDoorBottom = TILE_RIGHT_DOOR_BOTTOM
    gDoorOpen = TILE_RIGHT_DOOR_OPEN
  
  elseif tDir = MOVE_UP
    gExitX = PLAYERHARDRIGHT
    gExitY = PLAYERHARDTOP
    gTileXExit = TILE_RIGHT_OOB
    gTileYExit = TILE_TOP_IB
    gDoorTop = TILE_RIGHT_DOOR_TOP
    gDoorBottom = TILE_RIGHT_DOOR_BOTTOM
    gDoorOpen = TILE_RIGHT_DOOR_OPEN
  
  else ' move down
    gExitX = PLAYERHARDLEFT
    gExitY = PLAYERHARDBOTTOM
    gTileXExit = TILE_LEFT_OOB
    gTileYExit = TILE_BOTTOM_IB-1
  endif
  end sub


sub InitGameScreen(level as uByte)  
  gNeedInit = 2
  gCurrentTrack = cast(ubyte, MUSIC_GAME_1 + ((gLevel-1) mod MUSIC_TRACKS_COUNT))

  gTimer = GAMETICKSECOND
  gTimeToGo = (ySettingsSegregation + 3) * 15
  if gLevel>5 then gTimeToGo = gTimeToGo + (5 * (gLevel-5))  
  gTimeBetweenSpecials = 400
  gTimeNextSpecial = gTimeBetweenSpecials

  endGame=0
  gLevelTimeToGo = gTimeToGo ' need this for reset time purposes
  gDogMode = 0
  gSliding=0
  gCurrentPoo=0

  dim tDir as ubyte = gLevel mod 4
  InitLevelDirection(tDir)

  ResetPlayer(tDir)
  ResetNPCs(tDir)
  ResetSpecials()

  CLS256(COLOR_BACKGROUND)

  ' draw the top/bottom areas'
  for n = TILE_LEFT_OOB to TILE_RIGHT_OOB
    DoTileBank8(n, TILE_TOP_OOB, TILE_TOPBOTTOM, BANK_TILES)
    DoTileBank8(n, TILE_BOTTOM_OOB, TILE_TOPBOTTOM, BANK_TILES)
    DoTileBank8(n, TILE_BOTTOM_OOB+1, TILE_GREEN_BACKGROUND, BANK_TILES)
    DoTileBank8(n, TILE_BOTTOM_OOB+2, TILE_GREEN_BACKGROUND, BANK_TILES)
    ' draw the sides too
    if n > TILE_TOP_OOB and n < TILE_BOTTOM_OOB
      DoTileBank8(TILE_LEFT_OOB, n, TILE_BRICK_GREEN_LEFT, BANK_TILES)
      DoTileBank8(TILE_RIGHT_OOB, n, TILE_BRICK_GREEN_RIGHT, BANK_TILES)
    endif 
  next n  

  ' draw the 'exit'
  DoTileBank8(gTileXExit, gTileYExit, gDoorTop, BANK_TILES)
  DoTileBank8(gTileXExit, gTileYExit+1, gDoorBottom, BANK_TILES)


  ' finally, the HUD etc
  DoTileBank8(TILE_LEFT_OOB, TILE_BOTTOM_OOB+1, TILE_CLOCK1, BANK_TILES)
  DoTileBank8(TILE_LEFT_OOB+1, TILE_BOTTOM_OOB+1, TILE_CLOCK2, BANK_TILES)
  DoTileBank8(TILE_LEFT_OOB, TILE_BOTTOM_OOB+2, TILE_CLOCK3, BANK_TILES)
  DoTileBank8(TILE_LEFT_OOB+1, TILE_BOTTOM_OOB+2, TILE_CLOCK4, BANK_TILES)

  UpdateTime()

  dim m$ as string = right("00"+str(gLevel mod 100),2)
    L2Text(24, TILE_BOTTOM_OOB+2, "LEVEL " +m$, BANK_FONT, 0)
  
  for n=1 to gLives*2 step 2
    if n<11
      DoTileBank8(TILE_LEFT_OOB+11+n, TILE_BOTTOM_OOB+1, TILE_PLAYER1, BANK_TILES)
      DoTileBank8(TILE_LEFT_OOB+12+n, TILE_BOTTOM_OOB+1, TILE_PLAYER2, BANK_TILES)
      DoTileBank8(TILE_LEFT_OOB+11+n, TILE_BOTTOM_OOB+2, TILE_PLAYER3, BANK_TILES)
      DoTileBank8(TILE_LEFT_OOB+12+n, TILE_BOTTOM_OOB+2, TILE_PLAYER4, BANK_TILES)
    endif
  next n
  ' to do change this for something better'
  if gLives>5 then L2Text(22, TILE_BOTTOM_OOB+2, "#", BANK_FONT, 0)



end sub


sub NextLevel()
  gLevel=gLevel+1
  JumpScreen(LEVELSTARTSCREEN)
end sub


sub LifeOver()
  gLives=gLives-1
  if gLives=0
    JumpScreen(GAMEOVERSCREEN)
  else
    JumpScreen(LIFELOSTSCREEN)
  endif
end sub
  

sub CurrentDebug()
  Debounce(KEYSPACE)
end sub


sub UpdateTime()
  ' are we still tracking time?'
  if gTimeToGo > 0 
    ' get remaining time as actual minutes/seconds'
    dim mins as UINTEGER = gTimeToGo / 60
    dim secs as UINTEGER = gTimeToGo mod 60
    dim m$ as string = right("00"+str(mins), 2)
    dim s$ as string = right("00"+str(secs), 2)
    for n = 2 to 6
      DoTileBank8(n, TILE_BOTTOM_OOB+2, 4, BANK_TILES)
    next n
    L2Text(2, 23, m$+":"+s$, BANK_FONT, 0)
  endif

end sub


sub FlashPlayer(timer as ubyte)
  dim clr as ubyte = pClr<<4
  dim rt as ubyte = 50
  for l = 0 to timer
     UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITECLIMBDOWN, clr , 0)
     WaitRetrace(rt)
     UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITECLIMBDOWN, clr+ 2, 0)
     WaitRetrace(rt)
     UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITECLIMBDOWN, clr + 4, 0)
     WaitRetrace(rt)
     UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITECLIMBDOWN, clr+ 10 , 0)
     WaitRetrace(rt)
  next l
end sub

sub HandleCollision(npc as ubyte)
  if npc=SPRITE_MILK
    CollideMilk()
  elseif npc=SPRITE_CANE
    CollideCane()
  elseif npc=SPRITE_DOG
    CollideDog()
  elseif npc=SPRITE_DINNER
    CollideDinner()
  elseif npc=SPRITE_DUST
    CollideDust()
  elseif npc=SPRITE_SNATCHER
    CollideSnatcher()
  else
    cMode(npc) = MODE_INACTIVE
    PlaySound(SOUND_DEAD)
    FlashPlayer(10)    
    ' comment this to effectively turn-off death collisions'
    endGame = 1
  endif
end sub


sub LevelEnded()
  gTimeToGo = 0
  gTimer = 0
  PlaySound(SOUND_BELL)
  
  ' clear the timer part of the bottom display area
  for n = TILE_LEFT_OOB to 11
    DoTileBank8(n, TILE_BOTTOM_OOB+1, 4, BANK_TILES)
    DoTileBank8(n, TILE_BOTTOM_OOB+2, 4, BANK_TILES)
  next n
  L2Text(TILE_LEFT_OOB, TILE_BOTTOM_OOB+2, "BREAK OVER", BANK_FONT, 0)

  ' open the door
  DoTileBank8(gTileXExit, gTileYExit, gDoorOpen, BANK_TILES) 'TILE_GREEN_BACKGROUND, BANK_TILES)
  DoTileBank8(gTileXExit, gTileYExit+1, TILE_GREEN_BACKGROUND, BANK_TILES) 'TILE_GREEN_BACKGROUND, BANK_TILES)
  
  EverybodyOut()
end sub


sub HandleGameTime()
  ' handle overall game time
  if gTimer > 0
    gTimer = gTimer - 1

    gTimeNextSpecial = gTimeNextSpecial - 1
    if gTimeNextSpecial = 0 
      gTimeNextSpecial = gTimeBetweenSpecials ' may get changed im the spawner later'
      SpawnSpecial()
    endif  
  
  else
    if gTimeToGo > 1 ' still game time left'
      gTimeToGo = gTimeToGo - 1
      gTimer = GAMETICKSECOND
      UpdateTime()
    elseif gTimeToGo = 1 ' the level has ended, we have a one-time flagging-up
      LevelEnded()
      UpdateTime()
    endif
    ' doesn't update time any further once we're into 'leaving'
  endif
end sub


sub CheckLevelEnd()
  dim active as ubyte = 0
  for npc = 1 to SPRITE_COUNT
    if cMode(npc) > MODE_INACTIVE and cKind(npc)<>KIND_STATIC then active = active + 1
  next npc

  if active=0 then
    endGame = 2
    debugC = NO_RETAIN
  endif
end sub


sub HandlePooCollision(poo as ubyte)
  cPooTimer(poo) = 0
  if gSliding=0
    gSliding=1
    gSlideTimer=POO_SLIDE_TIMER
  endif
  PlaySound(SOUND_SLIDE)
end sub


sub UpdateGameItems()
  if endGame>0 then return

  ' poo check first
  if gDogMode = 1
    dim pooCount as ubyte = 0

    for poo = 1 to POO_COUNT
      if cPooMode(poo) = MODE_ACTIVE
        cPooTimer(poo) = cPooTimer(poo) - 1
        if cPooTimer(poo)>0 and cPooTimer(poo)<(POO_EXPIRY_TIMER-POO_DRAW_DELAY)
          if CheckPooCollision(poo) = COLLISION
            HandlePooCollision(poo)
          endif
        endif

        if cPooTimer(poo) = 0
          cPooMode(poo) = MODE_INACTIVE
          cPooTimer(poo) = 0
          RemoveSprite(POO_SPRITE_OFFSET+poo, 0)
        endif

        if cPooMode(poo) = MODE_ACTIVE then pooCount = pooCount + 1
      endif
    next poo

    if pooCount = 0 and cMode(SPRITE_DOG) = MODE_INACTIVE
      gDogMode = 0
    endif
  endif

  ' then collision check 
  for npc = 1 to SPRITE_COUNT
    if cMode(npc) > MODE_INACTIVE
      if CheckPlayerNPCCollision(npc) = COLLISION
        HandleCollision(npc)
        if endGame>0 then return
      endif
    endif
  next npc

  ' sliding?
  if gSliding=1
    gSlideTimer=gSlideTimer-1
    if gSlideTimer=0 then gSliding=0
  endif

  HandleGameTime()

  ' now process moves
  for npc = 1 to SPRITE_COUNT
    ' should we process this one?
    if endGame = 0 and cMode(npc) > MODE_INACTIVE
      ' are we counting down as frozen?
      if cFrozen(npc) > 0
        cFrozen(npc) = cFrozen(npc) - 1
        if cFrozen(npc) = 0 then ThawNPC(npc) ' reset for next time

      else
        ' are we counting down this NPC's own timer?
        if cTimer(npc) > 0
          cTimer(npc) = cTimer(npc) - 1
        else
          ' ok, time to take some action
          cTimer(npc) = cSpeed(npc) ' reset Timer

          ' don't do anything if it's static (though we got here in case we want to hook in anims or removals
          ' for the static items in future)
          if cKind(npc) <> KIND_STATIC

            ' move the animation
            cAnimFrame(npc) = cAnimFrame(npc) + 1
            if cAnimFrame(npc) > (NPCANIMFRAMECOUNT - 1) then cAnimFrame(npc) = 1
    
            ' chasers gonna chase
            if cKind(npc) = KIND_CHASER and (pOldx <> pXPos or pOldy <> pYPos)
              cTargetX(npc) = pXPos
              cTargetY(npc) = pYPos
              SetForTarget(npc)
            endif

            ' now actually move the NPC        
            if (cDir(npc) = MOVE_RIGHT) and (cXPos(npc) < cTargetX(npc))
              cXPos(npc) = cXPos(npc) + 1
            elseif (cDir(npc) = MOVE_LEFT) and (cXPos(npc) > cTargetX(npc))
              cXPos(npc) = cXPos(npc) - 1
            elseif (cDir(npc) = MOVE_UP) and (cYPos(npc) > cTargetY(npc))
              cYPos(npc) = cYPos(npc) - 1
            elseif (cDir(npc) = MOVE_DOWN) and (cYPos(npc) < cTargetY(npc))
              cYPos(npc) = cYPos(npc) + 1
            else
              if npc = SPRITE_DOG
                ChangeDog()
              elseif npc = SPRITE_DINNER
                ChangeDinner()
              elseif npc = SPRITE_SNATCHER
                ChangeSnatcher()
              else
                HandleNPCChange(npc)
              endif
            endif
          endif ' if KIND_STATIC

        endif
      endif
    endif
  next npc

  HandleDinnerSight()

  CheckLevelEnd()
end sub


sub SignalLeave(npc as ubyte)
  cTargetX(npc) = gExitX
  cTargetY(npc) = gExitY
  cKind(npc) = KIND_GO_EXIT
  cSpeed(npc) = 1 ' head back asap'
  cTimer(npc) = 0
  cAnimFrame(npc)=1
  SetForTarget(npc)
  HeadForTarget(npc)
end sub


sub ChangeDog()
  if cKind(SPRITE_DOG) = KIND_LEAVE
    RemoveSprite(SPRITE_DOG, 0)
    cMode(SPRITE_DOG) = MODE_INACTIVE ' deactivate sprite

  elseif cKind(SPRITE_DOG) <> KIND_GO_EXIT
    if cXPos(SPRITE_DOG)=cTargetX(SPRITE_DOG) and cYPos(SPRITE_DOG)=cTargetY(SPRITE_DOG)
      SignalLeave(SPRITE_DOG)    
    else
      SetForTarget(SPRITE_DOG)
    endif
  else
    HandleNPCChange(SPRITE_DOG)
  endif
end sub

sub ChangeDinner()
  if cKind(SPRITE_DINNER) = KIND_LEAVE
    RemoveSprite(SPRITE_DINNER, 0)
    cMode(SPRITE_DINNER) = MODE_INACTIVE
    gDinnerPlayerSeen = 0

  elseif cKind(SPRITE_DINNER) = KIND_GO_EXIT
    HandleNPCChange(SPRITE_DINNER)

  else
    if cXPos(SPRITE_DINNER) = cTargetX(SPRITE_DINNER) and _
       cYPos(SPRITE_DINNER) = cTargetY(SPRITE_DINNER)

      SetDinnerRoamTarget()
    else
      SetForTarget(SPRITE_DINNER)
    endif
  endif
end sub


'todo - this isn't right, she seems to be leaving abruptly on her way to the exit
sub ChangeSnatcher()
  if cKind(SPRITE_SNATCHER) = KIND_LEAVE
    RemoveSprite(SPRITE_SNATCHER, 0)
    cMode(SPRITE_SNATCHER) = MODE_INACTIVE ' deactivate sprite
  elseif cKind(SPRITE_SNATCHER) <> KIND_GO_EXIT
    if cMode(SPRITE_MILK) = MODE_ACTIVE
      if cXPos(SPRITE_SNATCHER)=cXPos(SPRITE_MILK) and cYPos(SPRITE_SNATCHER)=cYPos(SPRITE_MILK)
        CollideSnatcherMilk()
      else
        SetForTarget(SPRITE_SNATCHER)
      endif    
    else
      SignalLeave(SPRITE_SNATCHER)    
    endif
  else
    HandleNPCChange(SPRITE_SNATCHER)
  endif
end sub


sub HandleNPCChange(npc as ubyte)
  cAnimFrame(npc)=1 ' switch to standing frame
  
  if cKind(npc) = KIND_LEAVE
    RemoveSprite(npc, 0)
    cMode(npc) = MODE_INACTIVE ' deactivate sprite

  elseif cKind(npc) = KIND_BOUNCER
    'cPrivateTimer(npc) = cPrivateTimer(npc) - 1
    'if cPrivateTimer(npc) = 0 then cKind(npc) = KIND_GO_EXIT 'set to head for exit next

    'flip direction, will get more directional for harder NPCs
    if cDir(npc) < MOVE_UP
      cDir(npc) = MOVE_LEFT - cDir(npc)
    else
      cDir(npc) = (MOVE_DOWN - cDir(npc)) + MOVE_UP
    endif
    RetargetNPC(npc)

  elseif cKind(npc) = KIND_GO_EXIT
    if cXPos(npc)=cTargetX(npc) and cYPos(npc)=cTargetY(npc)
      cKind(npc) = KIND_LEAVE
      cTimer(npc) = 1
      cAnimFrame(npc)=1
    else 
      SignalLeave(npc)  
    endif  

  elseif cKind(npc) = KIND_CHASER
    SetForTarget(npc)
    HeadForTarget(npc)

  elseif cKind(npc) = KIND_TARGET ' fetchers aim for a target and then leave the screen
    if cXPos(npc) = cTargetX(npc) and cYPos(npc) = cTargetY(npc)
      ' now retarget the exit
      SignalLeave(npc)
    else
      SetForTarget(npc)
      HeadForTarget(npc)
    endif

  'elseif cKind(npc) = KIND_STATIC
  '  SetForTarget(npc)
  '  HeadForTarget(npc)
  
  'elseif cKind(npc) = KIND_WATCHER
  '  SetForTarget(npc)
  ''  HeadForTarget(npc)

  endif

end sub



sub UpdateGamePlayer()
  if endGame=1 then return

  dim clr as ubyte = pClr<<4
  if gSliding then
    if (pMoveDir=MOVE_RIGHT)
      UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITEWALK + pAnimFrame, clr+14 , 0)
    elseif (pMoveDir=MOVE_LEFT)
      UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITEWALK + pAnimFrame, clr + 6, 0)
    elseif (pMoveDir=MOVE_UP)
      UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITECLIMBDOWN +  pAnimFrame, clr+10, 0)
    elseif (pMoveDir=MOVE_DOWN)
      UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITECLIMBDOWN + pAnimFrame, clr+2 , 0)
    endif
  else
  if (pMoveDir=MOVE_RIGHT)
    UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITEWALK + pAnimFrame, clr , 0)
  elseif (pMoveDir=MOVE_LEFT)
    UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITEWALK + pAnimFrame, clr + 8, 0)
  elseif (pMoveDir=MOVE_UP)
    UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITECLIMBUP +  pAnimFrame, clr, 0)
  elseif (pMoveDir=MOVE_DOWN)
    UpdateSprite(pXPos, pYPos, 0, PLAYERSPRITECLIMBDOWN + pAnimFrame, clr , 0)
  endif
  endif

  for npc = 1 to SPRITE_NPC_COUNT
    if cMode(npc) > MODE_INACTIVE
    dim cclr as ubyte = cPalOffs(npc)<<4
      if cDir(npc) = MOVE_RIGHT
        UpdateSprite(cXPos(npc), cYPos(npc), npc, PLAYERSPRITEWALK + cAnimFrame(npc), cclr , 0)

      elseif cDir(npc) = MOVE_LEFT
        UpdateSprite(cXPos(npc), cYPos(npc), npc, PLAYERSPRITEWALK + cAnimFrame(npc), cclr+8 , 0)

      elseif cDir(npc) = MOVE_UP 
        UpdateSprite(cXPos(npc), cYPos(npc), npc, PLAYERSPRITECLIMBUP + cAnimFrame(npc), cclr , 0)

      elseif cDir(npc) = MOVE_DOWN
        UpdateSprite(cXPos(npc), cYPos(npc), npc, PLAYERSPRITECLIMBDOWN + cAnimFrame(npc), cclr , 0)
      endif
    endif
  next npc

  if cMode(SPRITE_DOG) > MODE_INACTIVE then UpdateDog()
  if cMode(SPRITE_DINNER) > MODE_INACTIVE then UpdateDinner()
  if cMode(SPRITE_SNATCHER) > MODE_INACTIVE then UpdateSnatcher()
  if cMode(SPRITE_MILK) > MODE_INACTIVE then UpdateMilk()
  if cMode(SPRITE_CANE) > MODE_INACTIVE then UpdateCane()
  if cMode(SPRITE_DUST) > MODE_INACTIVE then UpdateDust()

  if gDogMode=1
    for poo = 1 to POO_COUNT
      if cPooMode(poo) = MODE_ACTIVE and cPooTimer(poo)<(POO_EXPIRY_TIMER-POO_DRAW_DELAY)
        if cPooTimer(poo) = POO_EXPIRY_TIMER-POO_DRAW_DELAY-1 then PlaySound(SOUND_POO)
        UpdateSprite(cPooXPos(poo), cPooYPos(poo), POO_SPRITE_OFFSET + poo, POOSPRITE, 0, 0)
      endif 
    next poo
  endif

  if pTimer = 0
    pTimer = PLAYERANIMTIMER
    pAnimFrame = pAnimFrame + 1
    if pAnimFrame = PLAYERANIMFRAMECOUNT
      pAnimFrame = 1
    endif
  endif
  
end sub


sub ReadGameKeyboard()
  dim key as UINTEGER
  dim joy as byte
  if endGame = 1 then return

  key = 0 ' GetKeyScanCode()
  joy = in(31)
  ' if key = 0 and joy = 0 and gSliding = 0 then return

  if pFrozen > 0
    pFrozen = pFrozen - 1
    if pFrozen = 0 then ThawPlayer()
  else
    pOldx = pXPos
    pOldy = pYPos

    if gSliding = 1
      if pMoveDir = MOVE_RIGHT
        key = KEY_RIGHT 'KEYP
      elseif pMoveDir = MOVE_LEFT
        key = KEY_LEFT 'KEYO
      elseif pMoveDir = MOVE_UP
        key = KEY_UP 'KEYQ
      elseif pMoveDir = MOVE_DOWN
        key = KEY_DOWN 'KEYA
      endif
    endif


    if (key = KEY_RIGHT) or MultiKeys(KEY_RIGHT) or (joy bAnd JOY_RIGHT = JOY_RIGHT)
      if pMoveDir = MOVE_RIGHT
        if (pXPos < PLAYERHARDRIGHT)
          pXPos = pXPos + 1
          pTimer = pTimer-1
        endif
      else
        pMoveDir = MOVE_RIGHT
        pTimer = PLAYERANIMTIMER
        pAnimFrame = 0 
      endif
    
    elseif (key = KEY_LEFT) or MultiKeys(KEY_LEFT) or (joy bAnd JOY_LEFT = JOY_LEFT)
      if pMoveDir = MOVE_LEFT
        if (pXPos > PLAYERHARDLEFT)
          pXPos = pXPos - 1
          pTimer = pTimer-1
        endif
      else
        pMoveDir = MOVE_LEFT
        pTimer = PLAYERANIMTIMER
        pAnimFrame = 0 
      endif

    elseif (key = KEY_UP) or MultiKeys(KEY_UP) or (joy bAnd JOY_UP = JOY_UP)
      if pMoveDir = MOVE_UP
        if pYPos > PLAYERHARDTOP
          pYPos = pYPos - 1
          pTimer = pTimer-1
        endif
      else
        pMoveDir = MOVE_UP
        pTimer = PLAYERANIMTIMER
        pAnimFrame = 0
      endif

    elseif (key = KEY_DOWN) or MultiKeys(KEY_DOWN) or (joy bAnd JOY_DOWN = JOY_DOWN)
      if pMoveDir = MOVE_DOWN
        if pYPos < PLAYERHARDBOTTOM
          pYPos = pYPos + 1
          pTimer = pTimer-1
        endif 
      else
        pMoveDir = MOVE_DOWN
        pTimer = PLAYERANIMTIMER
        pAnimFrame = 0
      endif 
    endif
  endif

  if (MultiKeys(KEYSPACE) or (joy bAnd JOY_FIRE = JOY_FIRE)) and DEBUG_MODE > 0
    gTimer = 0
    ''CurrentDebug()

  elseif MultiKeys(KEY_ABORT) and DEBUG_MODE > 0
    Debounce(key)
    LifeOver()
  endif
end sub
