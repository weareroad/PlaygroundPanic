#define ATTRACTSCREEN 0
#define SETTINGSSCREEN 1
#define GAMEOVERSCREEN 2
#define HISCOREENTRYSCREEN 3
#define HISCORELISTSCREEN 4
#define LEVELSTARTSCREEN 5
#define KEYSSCREEN 8
#define LORESCREEN 9
#define GAMESCREEN 10
#define CREDITSCREEN 11
#define LIFELOSTSCREEN 12
#define LOOPSCREEN 254

#define BANK_FONT 32
#define BANK_SPRITES 36
#define BANK_TILES 34
#define BANK_PLAYER 42
#define BANK_
#define MOVE_UP 2
#define MOVE_DOWN 3
#define MOVE_RIGHT 0
#define MOVE_LEFT 1

#define JOY_UP 8
#define JOY_DOWN 4
#define JOY_LEFT 2
#define JOY_RIGHT 1
#define JOY_FIRE 16

#define KIND_LEAVE 0
#define KIND_BOUNCER 1
#define KIND_GO_EXIT 2
#define KIND_CHASER 3
#define KIND_TARGET 4
#define KIND_STATIC 5
#define KIND_WATCHER 6

#define COLOR_BACKGROUND 80
#define COLOR_RED 224
#define COLOR_BLACK 0

#define TILE_GREEN_BACKGROUND 4
#define TILE BRICK_TOP 5
#define TILE_BRICK_LEFT 6
#define TILE_BRICK_RIGHT 7
#define TILE_BLACK_BACKGROUND 20
#define TILE_TOPBOTTOM  9
#define TILE_BRICK_GREEN_LEFT 30
#define TILE_BRICK_GREEN_RIGHT 31
#define TILE_SETTING_SELECTED 14
#define TILE_SETTING_HIGHLIGHT 17 
#define TILE_POO 36
#define TILE_LEFT_DOOR_TOP 32 
#define TILE_RIGHT_DOOR_TOP 33
#define TILE_LEFT_DOOR_BOTTOM 34 
#define TILE_RIGHT_DOOR_BOTTOM 35
#define TILE_LEFT_DOOR_OPEN 40
#define TILE_RIGHT_DOOR_OPEN 41
#define TILE_CLOCK1 44
#define TILE_CLOCK2 45
#define TILE_CLOCK3 46
#define TILE_CLOCK4 47

#define TILE_BELL_BLACK 38
#define TILE_TIME_BLACK 39

#define TILE_PLAYER1 48
#define TILE_PLAYER2 49
#define TILE_PLAYER3 50
#define TILE_PLAYER4 51

' the number of NPCs, dynamic power-ups etc
#define SPRITE_COUNT 38
#define SPRITE_NPC_COUNT 30
#define ATTRACT_COUNT 10
#define BONUS_TEXT_COUNT 10

#define SPRITE_DOG 33
#define SPRITE_MILK 34
#define SPRITE_DINNER 32
#define SPRITE_DUST 31
#define SPRITE_SNATCHER 35
#define SPRITE_CANE 37
#define SPRITE_PLAYER 0

#define POO_COUNT 10
#define POO_SPRITE_OFFSET  (SPRITE_COUNT + 2)
#define POO_EXPIRY_TIMER  10800
#define POO_DRAW_DELAY 40

' there's an off-by-1 thing going on here
#define SOUND_GOT_CANE 78
#define SOUND_GOT_MILK 53
#define SOUND_GOT_DUST 52
#define SOUND_OUCH 91
#define SOUND_NPC_WIN 2
#define SOUND_NONE 0
#define SOUND_NPC_APPEAR 1
#define SOUND_ITEM_APPEAR 65
#define SOUND_DEAD 56
#define SOUND_POO 44
#define SOUND_SLIDE 48
#define SOUND_BELL 67

const GAME_VER as string = "VER 1.1A"

const MUSIC_ATTRACT as ubyte = 43
const MUSIC_GAME_1 as ubyte = 44
const MUSIC_GAME_2 as ubyte = 45
const MUSIC_GAME_3 as ubyte = 46
const MUSIC_GAME_4 as ubyte = 47
const MUSIC_ENDGAME as ubyte = 48
const MUSIC_LEVEL_1 as ubyte = 49
const MUSIC_LEVEL_2 as ubyte = 50
const MUSIC_LEVEL_3 as ubyte = 51
const MUSIC_LEVEL_4 as ubyte = 52
const HITS_COUNT as ubyte = 4

#define MODE_ACTIVE 1
#define MODE_INACTIVE 0
#define MODE_TRANSITION 2
#define MOVING 1
#define NOT_MOVING 0

#define NO_COLLISION 0
#define COLLISION 1

#define PUP_MAX 5
#define NO_RETAIN 0

#define TILE_LEFT_OOB  0
#define TILE_RIGHT_OOB 31
#define TILE_RIGHT_IB 30
#define TILE_LEFT_IB 1
#define TILE_TOP_IB 1
#define TILE_BOTTOM_IB 20
#define TILE_TOP_OOB 0
#define TILE_BOTTOM_OOB 21

CONST DEBUG_MODE as ubyte = 1 ' 0 for off, 1 for basic, 2 for sprite inits etc

CONST PLAYERANIMTIMER as ubyte = 5 ' how many WBlanks pass before we move the player anim forwards
CONST PLAYERSPRITEWALK as ubyte = 0 ' first sprite in walk sequence (first ones are the stand-still ones)
CONST PLAYERSPRITECLIMBUP as ubyte = 8 ' first sprite in climb up sequence (again, start with stood still)
CONST PLAYERSPRITECLIMBDOWN as ubyte = 16 ' first sprite in climb down (standing still at first)

CONST MILKSPRITE as ubyte = 7
CONST DUSTSPRITE as ubyte = 6
CONST CANESPRITE as ubyte = 13
CONST BELLSPRITE as ubyte = 21
CONST SNATCHERSPRITEWALK as ubyte = 36
CONST SNATCHERSPRITECLIMBUP as ubyte = 40
CONST SNATCHERSPRITECLIMBDOWN as ubyte = 44
CONST DINNERSPRITEWALK as ubyte = 48
CONST DINNERSPRITECLIMBUP as ubyte = 52
CONST DINNERSPRITECLIMBDOWN as ubyte = 56
CONST DOGSPRITEWALK as ubyte = 24
CONST DOGSPRITECLIMBUP as ubyte = 28
CONST DOGSPRITECLIMBDOWN as ubyte = 32
CONST POOSPRITE as ubyte = 5

CONST CANE_FREEZE as UINTEGER = 200
CONST DUST_FREEZE as UINTEGER = 200
CONST DINNER_FREEZE as UINTEGER = 150
CONST SNATCHER_FREEZE as UINTEGER = 150
CONST DOG_FREEZE as UINTEGER = 100
CONST MILK_TIME as ubyte = 15
CONST CANE_TIME as ubyte = 10

CONST PLAYERANIMFRAMECOUNT as ubyte = 4 ' how many frames in the player anim
CONST NPCANIMFRAMECOUNT as ubyte = 4 ' how many frames in the NPC anim
CONST PLAYERHARDLEFT as UINTEGER = 36 ' left edge of screen for sprite purposes
CONST PLAYERHARDRIGHT as UINTEGER = 269 ' right edge of screen for sprite purposes - remember to allow for sprite width
CONST PLAYERHARDTOP as ubyte = 39 ' top edge of screen for sprite purposes
CONST PLAYERHARDBOTTOM as ubyte = 185 ' bottom edge of screen for sprite purposes - remember to allow for sprite height


CONST SETTINGSTIMERWAIT as UINTEGER = 1000 ' inactivity timer, how long before we move the settings screen on
CONST GAMETICKSECOND as ubyte = 49 ' how many game ticks per real-world second (an approximation)!
CONST COLMARGIN as INTEGER = 10 ' number of pixels margin (overlap) in collision detection 
CONST SQRCOLMARGIN as INTEGER = 100 ' square of COLMARGIN, to save computation
CONST POOMARGIN as INTEGER = 8
CONST SQRPOOMARGIN as INTEGER = 64
CONST TIMER_TO_POO as UINTEGER = 350
CONST POO_SLIDE_TIMER as UINTEGER = 100

' due to their position in the file, these are (deliberately) basically global variables across the whole project
' bad form, but we're not writing enterprise code, we're writing a Spectrum Next game :-)
dim screenType as ubyte ' stores which screen we're on (game, keys, attract, hiscore etc)
dim gNeedInit as ubyte '  flag to say the current screen requires initialising
dim endGame as ubyte = 0 ' flag to indicate the game has ended'
dim gLevel as ubyte = 1 ' level counter - can be set from a user-input level code
dim gLives as ubyte = 3
dim gKeyStep as ubyte = 0 ' uysed on redefine keys screen

' the following 2 items could be replaced by a hard-coded asm db type table I guess
dim tInts(320) as INTEGER ' table of integers - this is just to avoid endless casting of UINTEGERS and ubytes into INTEGERS
dim tSqrs(13) as INTEGER ' table of squares - each element holds the square of it's index (is, element 9 contains 81)

dim ySpriteRange as ubyte = PLAYERHARDBOTTOM - PLAYERHARDTOP
dim xSpriteRange as UINTEGER = PLAYERHARDRIGHT - PLAYERHARDLEFT

dim pXPos as UINTEGER ' player X and Y
dim pYPos as ubyte
dim pAnimFrame as ubyte ' current animation frame for player'
dim pTimer as ubyte ' timer to trigger next frame of animation
dim pMoveDir as ubyte ' indicates direction player facing 0-3 (left, right, up, down)
dim pClr as ubyte = 2 ' palette offset'
dim pOldx as UINTEGER
dim pOldy as ubyte
dim pFrozen as UINTEGER

dim gTimer as ubyte ' global timer used in-game and on interstitial screens
dim gTimeToGo as UINTEGER ' countdown of number of secconds (approx) to end of current level
dim gExitX as UINTEGER = 0 ' where is the exit on the current screen X
dim gExitY as ubyte = 0 ' where is the exit on the current screen Y
dim gNextSpecial as ubyte = 0 ' tracking the next special thing to add
dim gLevelTimeToGo as UINTEGER ' maximum number of seconds for the level (same a gTimeToGo when level starts)
dim gTileXExit, gTileYExit as ubyte
dim gDoorTop, gDoorBottom, gDoorOpen as ubyte
dim gDogMode as ubyte = 0
dim gSliding as ubyte = 0
dim gSlideTimer as UINTEGER = 0
dim gCurrentPoo as ubyte = 0
dim gTimeNextSpecial as UINTEGER = 0
dim gTimeBetweenSpecials as UINTEGER = 1000
dim gBonusText(BONUS_TEXT_COUNT) as STRING
dim gBonusTextCount as ubyte = 0
dim gCurrentTrack as ubyte = 44
dim gLastTrack as ubyte = 0

' used for debugging stuff from the game screen
dim debugC as ubyte = 0
dim debugStr1 as STRING = " "
dim debugStr2 as STRING = " "

' 36 available NPCs (not using element 0 for NPCs)
dim cXPos(SPRITE_COUNT) as UINTEGER ' NPC X pos
dim cYPos(SPRITE_COUNT) as ubyte 'NPC Y pos
dim cKind(SPRITE_COUNT) as ubyte ' bouncer, chaser, leaver etc
dim cDir(SPRITE_COUNT) as ubyte ' direction of travel
dim cMode(SPRITE_COUNT) as ubyte ' 0=off, 1=active, more to come?
dim cSpeed(SPRITE_COUNT) as ubyte ' 1=fast, 4=slow
dim cTimer(SPRITE_COUNT) as ubyte ' holds current position in 'cSpeed' count above
dim cAnimFrame(SPRITE_COUNT) as ubyte ' which frame are we on
dim cTargetX(SPRITE_COUNT) as UINTEGER ' where is this NPC going X
dim cTargetY(SPRITE_COUNT) as ubyte ' where is this NPC going Y'
dim cPrivateTimer(SPRITE_COUNT) as UINTEGER ' used for making transitions between 'kinds' & other per-npc stuff
dim cFrozen(SPRITE_COUNT) as UINTEGER
dim cPalOffs(SPRITE_COUNT) as ubyte

dim cPooXPos(POO_COUNT) as UINTEGER ' NPC X pos
dim cPooYPos(POO_COUNT) as ubyte 'NPC Y pos
dim cPooMode(POO_COUNT) as ubyte ' 0=off, 1=active, more to come?
dim cPooTimer(POO_COUNT) as UINTEGER

dim tSettings as UINTEGER
dim ySettingsGame as ubyte = 0
dim ySettingsSchool as ubyte = 0'1
dim ySettingsSegregation as ubyte = 0'2
dim ySettingsHighlight as ubyte = 4

dim atXPos(ATTRACT_COUNT) as uinteger
dim atYPos(ATTRACT_COUNT) as ubyte
dim atMode(ATTRACT_COUNT) as ubyte
dim atTimer(ATTRACT_COUNT) as ubyte
dim atFrame(ATTRACT_COUNT) as ubyte
dim atDir(ATTRACT_COUNT) as ubyte
dim atSpeed(ATTRACT_COUNT) as ubyte
dim atPattern(ATTRACT_COUNT) as ubyte
dim atSprite(ATTRACT_COUNT) as ubyte
dim atFrameMax(ATTRACT_COUNT) as ubyte
dim atTargetX(ATTRACT_COUNT) as UINTEGER
dim atTargetY(ATTRACT_COUNT) as ubyte
dim atMove(ATTRACT_COUNT) as ubyte
dim atAttrib(ATTRACT_COUNT) as ubyte

dim KEY_LEFT as UINTEGER = KEYO
dim KEY_RIGHT as UINTEGER = KEYP
dim KEY_UP as UINTEGER = KEYQ
dim KEY_DOWN as UINTEGER = KEYA
dim KEY_FIRE as UINTEGER = KEYSPACE
dim KEY_ABORT as UINTEGER = KEY0
dim gKeyLeft as string = "O"
dim gKeyRight as string = "P"
dim gKeyUp as string = "Q"
dim gKeyDown as string = "A"
dim gKeyFire as string = "SPACE"
dim gKeyAbort as string = "0"

dim gHiNames(10) as string
dim gHiScores(10) as UINTEGER