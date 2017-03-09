;2016/08/15 Just like it says
PRO JOURNAL__20160815__MAKE_COLORBAR_MATCH_BINZHENGS

  COMPILE_OPT idl2,strictarrsubs

  LOADCT,83 ;Rainbow, but with purples trimmed at bottom and blue and red both stretched a bit

  TVLCT,red,green,blue,/GET

  redFac                    = 0.7
  blueFac                   = 2.0

  maxRedOffset              = 65

  IF N_ELEMENTS(maxRedOffset) EQ 0 THEN BEGIN
     maxRedOffset           = 0
  ENDIF

  bigRed                    = (WHERE(red EQ MAX(red),nSatRed))[maxRedOffset:-1]
  bigBlue                   = WHERE(blue EQ MAX(blue),nSatBlue)

  firstNoRed                = MIN(WHERE(red EQ 0))
  firstMaxRed               = MIN(bigRed)
  lastMaxBlue               = MAX(bigBlue)

  fixemRed                  = FIX((INDGEN(nSatRed-maxRedOffset))/redFac)
  fixemBlue                 = FIX((REVERSE(INDGEN(lastMaxBlue)))/blueFac)

  redNew                    = red
  blueNew                   = blue

  IF lastMaxBlue NE -1 AND firstNoRed NE 0 THEN BEGIN
     blueNew[0:lastMaxBlue-1]  = MAX(blue) - fixemBlue
  ENDIF
  redNew[bigRed]            = redNew[bigRed] - fixemRed

  TVLCT,redNew,green,blueNew
  MODIFYCT,84,'rainbowBaddest',redNew,green,blueNew

END