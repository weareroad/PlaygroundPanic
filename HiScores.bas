sub GenerateScoreTable()
  restore scoredata
  dim n as ubyte
  for n=1 to 10
    read gHiNames(n), gHiScores(n)
  next n
end sub
scoredata:
  data "ROAD",1000,"ADAM",950 
  data "ROB",900,"CLIVE",850 
  data "DIZZY",800,"WILLY",750 
  data "JETMAN",700,"HORACE",650 
  data "SABREMAN",600,"WALLY",550 


' Bytes 0–3     "PPHS"
' Byte 4        format version, initially 1
' Byte 5        entry count, 10
' Bytes 6–125   ten records:
'                  8 name bytes
'                  4 score bytes, ULONG

sub PackHiScores()
  dim n as ubyte
  dim m as ubyte
  dim idx as UINTEGER
  dim name$ as string

  ' Clear the entire buffer
  for idx=0 to HISCORE_FILE_SIZE-1
    gSaveBuffer(idx)=0
  next idx

  ' File header: "PPHS", version, entry count
  gSaveBuffer(0)=code("P")
  gSaveBuffer(1)=code("P")
  gSaveBuffer(2)=code("H")
  gSaveBuffer(3)=code("S")
  gSaveBuffer(4)=HISCORE_FILE_VERSION
  gSaveBuffer(5)=HISCORE_COUNT

  idx=HISCORE_HEADER_SIZE

  ' The existing runtime arrays use entries 1 through 10
  for n=1 to HISCORE_COUNT
    name$=gHiNames(n)

    ' Fixed-width, zero-padded name
    for m=0 to HISCORE_NAME_LENGTH-1
      if m<len(name$)
        gSaveBuffer(idx)=code(name$(m))
      else
        gSaveBuffer(idx)=0
      endif

      idx=idx+1
    next m

    ' Four-byte little-endian score
    poke ULONG @gSaveBuffer(0)+idx,gHiScores(n)
    idx=idx+4
  next n
end sub

function HiScoreBufferIsValid() as ubyte
  dim n as ubyte
  dim m as ubyte
  dim c as ubyte
  dim idx as UINTEGER
  dim nameEnded as ubyte

  ' Check the file signature
  if gSaveBuffer(0)<>code("P") then return 0
  if gSaveBuffer(1)<>code("P") then return 0
  if gSaveBuffer(2)<>code("H") then return 0
  if gSaveBuffer(3)<>code("S") then return 0

  ' Check that this is a format we understand
  if gSaveBuffer(4)<>HISCORE_FILE_VERSION then return 0
  if gSaveBuffer(5)<>HISCORE_COUNT then return 0

  idx=HISCORE_HEADER_SIZE

  ' Check the fixed-width name fields
  for n=1 to HISCORE_COUNT
    nameEnded=0

    for m=0 to HISCORE_NAME_LENGTH-1
      c=gSaveBuffer(idx)

      if c=0
        nameEnded=1
      else
        ' Names must contain printable characters
        if c<32 or c>126 then return 0

        ' Once padding starts, the rest must also be padding
        if nameEnded=1 then return 0
      endif

      idx=idx+1
    next m

    ' Skip the four-byte ULONG score
    idx=idx+4
  next n

  return 1
end function


sub UnpackHiScores()
  dim n as ubyte
  dim m as ubyte
  dim c as ubyte
  dim idx as UINTEGER
  dim name$ as string

  idx=HISCORE_HEADER_SIZE

  for n=1 to HISCORE_COUNT
    name$=""

    for m=0 to HISCORE_NAME_LENGTH-1
      c=gSaveBuffer(idx)

      if c<>0
        name$=name$+chr(c)
      endif

      idx=idx+1
    next m

    gHiNames(n)=name$

    gHiScores(n)=peek(ULONG,@gSaveBuffer(0)+idx)
    idx=idx+4
  next n
end sub


sub SaveHiScores()
 dim filename$ as string = "Panic.hi"

  PackHiScores()
  SaveSD(filename$,@gSaveBuffer(0),HISCORE_FILE_SIZE)
end sub


sub LoadHiScores()
  dim filename$ as string = "Panic.hi"

  ' Read one byte beyond the expected size so oversized files are rejected.
  LoadSD(filename$,@gSaveBuffer(0),HISCORE_FILE_SIZE+1,0)

  ' Missing file or another SD-card error: retain built-in defaults.
  if peek(ubyte,@file_result)<>0 then return

  ' Reject truncated files and files from an unexpected format.
  if peek(UINTEGER,@filesize)<>HISCORE_FILE_SIZE then return

  ' Do not alter the live table unless the entire buffer is valid.
  if HiScoreBufferIsValid()=0 then return

  UnpackHiScores()
end sub

