# include <keys.bas>
' difference between GameHelpers and Helpers is that GameHelpers knows about the game, the global vars etc,
' and Helpers is more general-purpose sprite/machine type stuff

function ResetNext() as byte
  NextReg(2,1)
  return 0
end function 

function SpaceOrFire() as byte
  if in(31)=JOY_FIRE
    do 
      asm
        halt
      end asm
    loop until in(31)=0
    return 1
  endif

  if GetKeyScanCode()=KEYSPACE
    do 
      asm
       halt
      end asm
    loop until GetKeyScanCode()=0
    return 1
  endif

  return 0
end function


sub GameInit()
  gLives = 3
  gNextSpecial = 0
end sub 


function PadUByte(value as ubyte, length as ubyte) as string
  dim result as string = ""
  result = Str(value)
  do until len(result)>=length
    result = " " + result
  loop
  return result
end function

function PadUInt(value as UINTEGER, length as ubyte) as string
  dim result as string = ""
  result = Str(value)
  do until len(result)>=length
    result = " " + result
  loop
  return result
end function

function CentreStr(value as string, length as ubyte) as string
  dim result as string = ""
  result = value
  do until len(result)>=length
    result = " " + result
    if len(result)<length then result = result + " "
  loop
  return result
end function 


' indicate we want to move to a new screen, tripping the gNeedInit flag along the way
sub JumpScreen(screen as ubyte)
  screenType = screen
  gNeedInit = 1
end sub


sub IncreaseTime(seconds as ubyte)
  gTimeToGo = gTimeToGo + seconds
  if gTimeToGo > gLevelTimeToGo then gTimeToGo = gLevelTimeToGo
end sub


sub ReduceTime(seconds as uByte)
  if gTimeToGo>seconds
    gTimeToGo = gTimeToGo - seconds
  else
    gTimeToGo = 1
  endif
end sub


sub FreezeNPCs(frames as UINTEGER)
  for npc=1 to SPRITE_NPC_COUNT
    cFrozen(npc) = frames
    cPalOffs(npc)=3
  next npc
end sub


sub FreezePlayer(frames as UINTEGER)
pClr = 3  
pFrozen = frames
end sub


sub ThawNPC(npc as ubyte)
  cFrozen(npc) = 0
  cPalOffs(npc) = 0
end sub


sub ThawPlayer()
  pClr=2
  pFrozen = 0
end sub

sub UpdateAttractSprites()
for att = 1 to ATTRACT_COUNT
if atMode(att) = MODE_ACTIVE
  atTimer(att) = atTimer(att) - 1
  if atTimer(att) = 0
    atTimer(att) = atSpeed(att)
    atFrame(att) = atFrame(att)+1
    if atFrame(att) >= atFrameMax(att)
      atFrame(att) = 0
    endif

    if atMove(att)>0
      if (atDir(att) = MOVE_RIGHT) and (atXPos(att) < atTargetX(att))
        atXPos(att) = atXPos(att) + 1
      elseif (atDir(att) = MOVE_LEFT) and (atXPos(att) > atTargetX(att))
        atXPos(att) = atXPos(att) - 1
      elseif (atDir(att) = MOVE_UP) and (atYPos(att) > atTargetY(att))
        atYPos(att) = atYPos(att) - 1
      elseif (atDir(att) = MOVE_DOWN) and (atYPos(att) < atTargetY(att))
        atYPos(att) = atYPos(att) + 1
      endif
    endif
  endif
endif
next att

for att = 1 to ATTRACT_COUNT
if atMode(att) = MODE_ACTIVE
  UpdateSprite(atXPos(att), atYPos(att), att, atPattern(att)+atFrame(att), atAttrib(att), 0)
elseif atMode(att) = MODE_TRANSITION
  RemoveSprite(att, 0)
  atMode(att)=MODE_INACTIVE
endif
next att
end sub

sub ResetAttract()
  for att = 1 to ATTRACT_COUNT
    atMode(att) = MODE_INACTIVE
  next att
end sub


sub FlipAttractSprite(spr as ubyte)
  if spr=1
    dim clr as ubyte = pClr<<4
    if atDir(spr)=MOVE_RIGHT
      SetupAttract(spr, PLAYERSPRITEWALK+1, PLAYERHARDRIGHT, 210, PLAYERHARDLEFT, 210, 4, PLAYERANIMFRAMECOUNT, MOVE_LEFT, 8+clr, MOVING)
    else
      tSettings=0 ' trip next screen
      SetupAttract(spr, PLAYERSPRITEWALK+1, PLAYERHARDLEFT, 210, PLAYERHARDRIGHT, 210, 4, PLAYERANIMFRAMECOUNT, MOVE_RIGHT, clr, MOVING)
    endif
  endif
end sub


sub SetupAttract(sprNum as ubyte, sprPtn as ubyte, startX as UINTEGER, startY as ubyte, endX as UINTEGER, endY as ubyte, speed as ubyte, frames as ubyte, dir as ubyte, attrib as ubyte, moving as ubyte)
  atPattern(sprNum) = sprPtn
  atXPos(sprNum) = startX
  atYPos(sprNum) = startY
  atTargetX(sprNum) = endX
  atTargetY(sprNum) = endY
  atSpeed(sprNum) = speed
  atFrameMax(sprNum) = frames
  atFrame(sprNum) = 0
  atTimer(sprNum) = speed
  atMove(sprNum) = moving
  atDir(sprNum) = dir
  atAttrib(sprNum) = attrib
  atMode(sprNum) = MODE_ACTIVE
end sub


' find non-occupied space in middle 3rd of screen (want a few 'tiles' between this and nearest wall)
function GetClearXPos as UINTEGER
  ' 32 from each side anyway, then want 16 in from each side, so 320 - (64+32)=224, because always adding 48, mod is 176
  dim seed as UINTEGER = gLevel mod 5
  return 48 + ((gTimeToGo * (8+seed)) mod 196)
end function


function GetClearYPos as ubyte
  ' 32 from each side, then 16 in, so 240 - (64+32) = 144, because always adding 48, mod is 96
  dim seed as UINTEGER = gLevel mod 5
  return 48 + ((gTimeToGo * (16+seed)) mod 120)
end function


function CheckPooCollision(poo as ubyte) as ubyte
  dim dx as INTEGER = abs(tInts(cPooXPos(poo)) - tInts(pXPos))
  dim dy as INTEGER = abs(tInts(cPooYPos(poo)) - tInts(pYPos))
  ' if either dimension is greater than margin, early bail
  if (dx > POOMARGIN) or (dy > POOMARGIN) then return NO_COLLISION

  ' ok, possibly close enough to make it worth calculating
  dim sx as INTEGER = tSqrs(dx)
  dim sy as INTEGER = tSqrs(dy)
  dim sum as INTEGER = sx+sy
  if sum > SQRPOOMARGIN
    return NO_COLLISION
  else
    return COLLISION
  endif
end function


' collision detection for NPC 'npc' against the player
function CheckPlayerNPCCollision(npc as ubyte) as ubyte
  dim dx as INTEGER = abs(tInts(cXPos(npc)) - tInts(pXPos))
  dim dy as INTEGER = abs(tInts(cYPos(npc)) - tInts(pYPos))
  ' if either dimension is greater than margin, early bail
  if (dx > COLMARGIN) or (dy > COLMARGIN) then return NO_COLLISION
  
  ' ok, possibly close enough to make it worth calculating
  dim sx as INTEGER = tSqrs(dx)
  dim sy as INTEGER = tSqrs(dy)
  dim sum as INTEGER = sx+sy
  if sum > SQRCOLMARGIN
    return NO_COLLISION
  else
    if DEBUG_MODE > 0
      debugC = npc
      debugStr1 = "p"+str(pXPos)+","+str(pYPos)+":"+str(cXPos(npc))+","+str(cYPos(npc))
      'debugStr2 = "d"+str(dx)+","+str(dy)+":"+str(sx)+","+str(sy)
  ''    debugStr2 = tInts(str(dx)+","+str(dy)+":"+str(sx)+","+str(sy)
    else
      debugC = NO_RETAIN
      debugStr1 = " "
      debugStr2 = " "
    endif
    return COLLISION
  endif
end function




' intended to help set-up a 'look at the target' kind of thing, we use it to point in the right direction
sub SetForTarget(npc as ubyte)
  if npc mod 2=1
    if cXPos(npc) < cTargetX(npc)
      cDir(npc) = MOVE_RIGHT
    elseif cXPos(npc) > cTargetX(npc)
      cDir(npc) = MOVE_LEFT
    elseif cYPos(npc) > cTargetY(npc)
      cDir(npc) = MOVE_UP
    elseif cYPos(npc) < cTargetY(npc) 
      cDir(npc) = MOVE_DOWN
    endif
  else
    if cYPos(npc) > cTargetY(npc)
      cDir(npc) = MOVE_UP
    elseif cYPos(npc) < cTargetY(npc) 
      cDir(npc) = MOVE_DOWN
    elseif cXPos(npc) < cTargetX(npc)
      cDir(npc) = MOVE_RIGHT
    elseif cXPos(npc) > cTargetX(npc)
      cDir(npc) = MOVE_LEFT
    endif
  endif

end sub


' move towards the target
sub HeadForTarget(npc as ubyte)
  dim oldX as UINTEGER = cXPos(npc)
  dim oldY as ubyte = cYPos(npc)
  if cDir(npc) = MOVE_RIGHT and cXPos(npc) < cTargetX(npc)
     cXPos(npc) = cXPos(npc) + 1
  elseif cDir(npc) = MOVE_LEFT and cXPos(npc) > cTargetX(npc)
    cXPos(npc) = cXPos(npc) - 1
  elseif cDir(npc) = MOVE_UP and cYPos(npc) > cTargetY(npc) 
    cYPos(npc) = cYPos(npc) - 1
  elseif cDir(npc) = MOVE_DOWN and cYPos(npc) < cTargetY(npc)
    cYPos(npc) = cYPos(npc) + 1
  endif

  if oldX = cXPos(npc) and oldY = cYPos(npc)
    cAnimFrame(npc) = 0   ' make them appear still
    SetForTarget(npc)
  endif
end sub




' ensure no specials are running
sub ResetSpecials()
  cMode(SPRITE_DOG) = MODE_INACTIVE
  cMode(SPRITE_DINNER) = MODE_INACTIVE
  cMode(SPRITE_SNATCHER) = MODE_INACTIVE
  cMode(SPRITE_MILK) = MODE_INACTIVE
  cMode(SPRITE_CANE) = MODE_INACTIVE
  cMode(SPRITE_DUST) = MODE_INACTIVE

  cAnimFrame(SPRITE_DOG) = 0
  cSpeed(SPRITE_DOG) = 4 
  cAnimFrame(SPRITE_DINNER) = 0
  cSpeed(SPRITE_DINNER) = 5 
  cAnimFrame(SPRITE_SNATCHER) = 0
  cSpeed(SPRITE_SNATCHER) = 4 
  gDogMode = 0
  for poo = 1 to POO_COUNT
    cPooMode(poo) = MODE_INACTIVE
    cPooTimer(poo) = 0
  next poo
end sub


' reset individual NPC
sub ResetNPC(npc as ubyte)
  cKind(npc) = KIND_BOUNCER
  cMode(npc) = MODE_INACTIVE
  cDir(npc) = MOVE_RIGHT
  cYPos(npc) = PLAYERHARDTOP
  cXPos(npc) = PLAYERHARDLEFT
  cAnimFrame(npc) = (npc * 3) MOD (NPCANIMFRAMECOUNT + 1) ' start them all at distributed positions in the animations
  cSpeed(npc) = 5 '1 + (npc MOD 4) 
  cTimer(npc) = 0
  cTargetX(npc) = 0
  cTargetY(npc) = 0
  cPrivateTimer(npc) = 0
  cFrozen(npc) = 0
  cPalOffs(npc) = 0
end sub



' Reset *ALL* NPCs - dir is the direction they're going to come from
sub ResetNPCs(dir as ubyte)
  ' inital global reset
  for npc = 1 to SPRITE_COUNT
    ResetNPC(npc)
  next npc

  dim cCount as ubyte = 6
  ' if we're coming vertical then add more NPCs (more horizontal space)
  if dir > MOVE_LEFT then cCount = cCount + 4
  
  ' add more NPCs depending on 'school size'
  cCount = cCount + (ySettingsSchool * 7)

  for npc = 1 to cCount
    ' pick some starting positions
    dim yOffs as ubyte = (npc * 15) mod 24 '32
    dim xOffs as UINTEGER = ((npc * 15) mod 48) '64)
    dim cx as UINTEGER = PLAYERHARDLEFT + ((npc*16) mod xSpriteRange)
    dim cy as ubyte = PLAYERHARDTOP + (((npc-1)*16) mod ySpriteRange)

    cMode(npc) = MODE_ACTIVE
    cKind(npc) = KIND_BOUNCER
    cPrivateTimer(npc) = npc mod 6 ' some many 'HandleNPC' calls, we'll potentially change 'kind'
    cDir(npc) = dir
    if npc mod 3 <> 0
      cSpeed(npc) = 4 - ySettingsSegregation
    else
       cSpeed(npc) = 2 + (npc mod 5)
    endif    
    cTimer(npc) = cSpeed(npc)
    cXPos(npc) = cx
    cYPos(npc) = cy

    if npc mod 5 = 0 then
      cKind(npc) = KIND_CHASER
      cTargetX(npc) = pXPos
      cTargetY(npc) = pYPos
    else
      ' remember these directions are effectively flipped as they're where the NPC is facing
      cTargetX(npc) = cx
      cTargetY(npc) = cy
      RetargetNPC(npc)
    endif

    if cDir(npc) = MOVE_RIGHT
      cXPos(npc) = PLAYERHARDLEFT + xOffs 
    elseif cDir(npc) = MOVE_LEFT
      cXPos(npc) = PLAYERHARDRIGHT - xOffs  
    elseif cDir(npc) = MOVE_UP
      cYPos(npc) = PLAYERHARDBOTTOM - yOffs
    elseif cDir(npc) = MOVE_DOWN
      cYPos(npc) = PLAYERHARDTOP + yOffs
    endif
  next npc
end sub


' flip the NPC to be targetting the opposite wall, effectively
sub RetargetNPC(npc as ubyte)
  if cDir(npc) = MOVE_RIGHT
    cTargetX(npc) = PLAYERHARDRIGHT
  elseif cDir(npc) = MOVE_LEFT
    cTargetX(npc) = PLAYERHARDLEFT
  elseif cDir(npc) = MOVE_UP
    cTargetY(npc) = PLAYERHARDTOP
  elseif cDir(npc) = MOVE_DOWN
    cTargetY(npc) = PLAYERHARDBOTTOM
  endif
end sub


' reset the player, again dir is the direction to 'face'
sub ResetPlayer(dir as ubyte)
  ' use dir to give us positioning clues
  dim yMid as ubyte = PLAYERHARDTOP + cast(ubyte, (PLAYERHARDBOTTOM-PLAYERHARDTOP)  / 2)
  dim xMid as UINTEGER = PLAYERHARDLEFT + cast(UINTEGER, (PLAYERHARDRIGHT-PLAYERHARDLEFT) / 2) 
  pYPos = yMid
  pXPos = xMid

  if dir = MOVE_RIGHT
    pMoveDir = MOVE_LEFT
    pXPos = PLAYERHARDRIGHT - 4
  elseif dir = MOVE_LEFT
    pMoveDir = MOVE_RIGHT
    pXPos = PLAYERHARDLEFT + 4
  elseif dir = MOVE_UP
    pMoveDir = MOVE_DOWN
    pYPos = PLAYERHARDTOP + 4
  elseif dir = MOVE_DOWN
    pMoveDir = MOVE_UP
    pYPos = PLAYERHARDBOTTOM - 4
  endif
  if ySettingsSegregation>2 then
    pTimer = PLAYERANIMTIMER - 1
  else 
    pTimer = PLAYERANIMTIMER
  endif
  pAnimFrame = 0 
  pOldx = pXPos
  pOldy = pYPos
  pFrozen = 0
  pClr=2
end sub

sub AllSpritesOff()
  NPCSpritesOff(NO_RETAIN)
  PlayerSpriteOff()
  SpecialSpritesOff()
end sub

' kill all the NPC sprites, optionally leaving one (handy for debug)
sub NPCSpritesOff(retain as ubyte)
  for npc = 1 to SPRITE_NPC_COUNT
    if npc = retain
      if cDir(npc) = MOVE_RIGHT
        UpdateSprite(cXPos(npc), cYPos(npc), npc, PLAYERSPRITEWALK + cAnimFrame(npc), 0 , 0)

      elseif cDir(npc) = MOVE_LEFT
        UpdateSprite(cXPos(npc), cYPos(npc), npc, PLAYERSPRITEWALK + cAnimFrame(npc), 8 , 0)

      elseif cDir(npc) = MOVE_UP
        UpdateSprite(cXPos(npc), cYPos(npc), npc, PLAYERSPRITECLIMBUP + cAnimFrame(npc), 0 , 0)

      elseif cDir(npc) = MOVE_DOWN
        UpdateSprite(cXPos(npc), cYPos(npc), npc, PLAYERSPRITECLIMBDOWN + cAnimFrame(npc), 0 , 0)
      endif
    else
      RemoveSprite(npc, 0)
    endif
  next npc
end sub

sub SpecialSpritesOff()
  RemoveSprite(SPRITE_CANE,0)
  RemoveSprite(SPRITE_DINNER,0)
  RemoveSprite(SPRITE_DUST,0)
  RemoveSprite(SPRITE_MILK,0)
  RemoveSprite(SPRITE_DOG,0)
  RemoveSprite(SPRITE_SNATCHER,0)
  for poo = 1 to POO_COUNT
    RemoveSprite(POO_SPRITE_OFFSET+poo,0)
  next poo
end sub


sub ChangeMusic()
  if gCurrentTrack <> gLastTrack
    DisableMusic

    InitMusic(42, gCurrentTrack, 0)
    SetUpIM()
    EnableMusic

    gLastTrack = gCurrentTrack
  endif
  gNeedInit=0
end sub


sub ResetBonusText()
  for bon=1 to BONUS_TEXT_COUNT
    gBonusText(bon)=" "
  next bon
  gBonusTextCount=0
end sub

sub GenEndLevelBonusText()
  ResetBonusText()
  RESTORE  bonus:
  dim lim as uinteger = (gLevel-1) mod 13
  dim a$ = ""
  for bon=1 to lim+1 : read a$: next bon
  gBonusText(1)=a$
  gBonusTextCount=1
  end sub

bonus:  
  data "A PACK OF MOTORBIKE TOPTRUMPS"
  data "A PACKET OF SPANGLES"
  data "A WHAM BAR"
  data "LAST WEEK'S SMASH HITS"
  data "A COPY OF LOOK-IN"
  data "A SCREWBALL BUBBLY"
  data "A PACK OF ESPANIA 82 STICKERS"
  data "A CHERRY MR. FREEZE"
  data "A BAG OF WALKERS SNAPS"
  data "A 10P MIX"
  data "A KIDS FROM FAME VHS"
  data "AN AIRWOLF POSTER"
  data "A DR WHO TARGET NOVEL"
  data "A TOP CAT COLOURING BOOK"


sub GenEndGameBonusText()
  ResetBonusText()
  RESTORE gameoverbonus:
  dim lim as uinteger = (gLevel-1) mod 12
  dim a$ = ""
  for bon=1 to lim+1 : read a$: next bon
  gBonusText(1)=a$
  gBonusTextCount=1
end sub

gameoverbonus:  
  data "A TICKET TO THE LA OLYMPICS"
  data "A MINER'S STRIKE"
  data "A FALKLANDS WAR"
  data "BLAKE'S 7 GOT CANCELLED"
  data "A VESTA CHOW MEIN MEAL"
  data "A COLD WAR"
  data "TRICKLE-DOWN ECONOMICS"
  data "A CHALLENGER SHUTTLE DISASTER"
  data "AN ACORN ELECTRON"
  data "A CHEWED-UP TDK C-90"
  data "A CHERNOBYL DISASTER"
  data "BOB PAISLEY LEAVES LIVERPOOL"

sub GenEndLifeBonusText()
  ResetBonusText()
  RESTORE endlifebonus:
  ' keeps picking pepsi and shirley!
  dim lim as uinteger = ((gLevel-1) * (gLives+1)) mod 9
  dim a$ = ""
  for bon=1 to lim+1 : read a$: next bon
  gBonusText(1)=a$
  gBonusTextCount=1
end sub

endlifebonus:  
  data "A PEPSI ' SHIRLEY POSTER"
  data "LAST WEEK(S TV TIMES"
  data "A PART IN THE SCHOOL PLAY"
  data "A SCRATCHED FRANKIE SINGLE"
  data "SOME SKINNY STONEWASHED JEANS"
  data "SOME CHOCOLATE HUBBA-BUBBA"
  data "A BLUE PETER BADGE"
  data "A MULLET HAIR-CUT"
  data "A CHOCOLATE CIGAR"
  data "A LITTLE BLUE BAG OF SALT"

