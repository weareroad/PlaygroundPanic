
' patches & hacks for Sprite handling


' placeholder
sub PlaySound(sfx as ubyte)
  ' special case - on the game screen, once the bell needs to be rung, don't allow other SFX
  if screenType = GAMESCREEN and _
     gTimeToGo = 0 and _
     sfx <> SOUND_BELL then return
  
	PlaySFX(sfx)
end sub



' don't return until the specfied key is NOT/no longer pressed
sub Debounce(key as UINTEGER)
  do
    WaitRetrace(1)
  loop until GetKeyScanCode() <> key
end sub


sub PlayerSpriteOff()
  RemoveSprite(SPRITE_PLAYER, 0)
end sub



function ScanCodeToString(key as UINTEGER) as string
  dim res as string = "?"
  if key=KEYB
    res="B"
  elseif key = KEYN
    res="N"
  elseif key =KEYM
    res="M"
  elseif key =KEYSYMBOL
    res="SYM"
  elseif key =KEYSPACE
    res="SPACE"
  elseif key =KEYH
    res="H"
  elseif key =KEYJ
    res="J"
  elseif key =KEYK
    res="K"
  elseif key =KEYL 
    res="L"
  elseif key =KEYENTER 
    res="ENTER"
  elseif key =KEYY 
    res="Y"
  elseif key =KEYU 
    res="U"
  elseif key =KEYI 
    res="I"
  elseif key =KEYO 
    res="O"
  elseif key =KEYP 
    res="P"
  elseif key =KEY6 
    res="6"
  elseif key =KEY7 
    res="7"
  elseif key =KEY8 
    res="8"
  elseif key =KEY9 
    res="9"
  elseif key =KEY0 
    res="0"
  elseif key =KEY5 
    res="5"
  elseif key =KEY4 
    res="4"
  elseif key =KEY3 
    res="3"
  elseif key =KEY2 
    res="2"
  elseif key =KEY1 
    res="1"
  elseif key =KEYT 
    res="T"
  elseif key =KEYR 
    res="R"
  elseif key =KEYE 
    res="E"
  elseif key =KEYW 
    res="W"
  elseif key =KEYQ 
    res="Q"
  elseif key =KEYG 
    res="G"
  elseif key =KEYF 
    res="F"
  elseif key =KEYD 
    res="D"
  elseif key =KEYS 
    res="S"
  elseif key =KEYA 
    res="A"
  elseif key =KEYV 
    res="V"
  elseif key =KEYC 
    res="C"
  elseif key =KEYX 
    res="X"
  elseif key =KEYZ 
    res="Z"
  elseif key =KEYCAPS 
    res="CAPS"
  endif

  return res
end function

