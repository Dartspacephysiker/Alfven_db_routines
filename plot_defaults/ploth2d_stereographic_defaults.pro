;2015/10/21
;Maybe this makes life a little easier

  ;; charSize                    = cgDefCharSize()*((N_ELEMENTS(wholeCap) EQ 0) ? 1.0 : 0.7 )
  ;; charSize = cgDefCharSize()*((N_ELEMENTS(wholeCap) EQ 0) ? 1.3 : 0.7 )
  charSize                    = cgDefCharSize()*1.3

  ;;Default map position
  defH2DMapPosition           = [0.15, 0.05, 0.85, 0.75]

  def_H2D_xSize               = 5
  def_H2D_ySize               = 5

  ;;******************************
  ;;For presentations
  ;;******************************
  charSize_plotTitle_pres     = 2.5
  charSize_cbLabel_pres       = 2.7
  cbPosition_pres             = [0.05, 0.86, 0.95, 0.88]
  
  ;;******************************
  ;;Color tables
  ;;******************************

  ;;Number of colors in the colorbar
  nLevels                     = 255
  ;; nLevels                     = 13

  ;;color table options when all values are positive or logged
  chrisPosScheme              = 1

  IF chrisPosScheme THEN BEGIN
     ;; ctIndex_allPosData       = 39 ;This, I believe, is the color table that Chris Chaston likes
     ;; ctBrewer_allPosData      = 0
     ;; ctReverse_allPosData     = 0
     ;; maskColor                = "light gray"
     ;; defGridColor             = "black"
     ;; ;; defGridTextColor         = "dark gray"
     ;; defGridTextColor         = "black"

     ;;Alternate for comparison to Polar and LFM
     ctIndex_allPosData       = 39 ;This, I believe, is the color table that Chris Chaston likes
     ctBrewer_allPosData      = 0
     ctReverse_allPosData     = 0
     maskColor                = "dark gray"
     defGridColor             = "white"
     ;; defGridTextColor         = "dark gray"
     defGridTextColor         = "white"


  ENDIF ELSE BEGIN
     ctIndex_allPosData       = 16 ;This is the one I usually use
     ctBrewer_allPosData      = 1
     ctReverse_allPosData     = 0
     maskColor                = "gray"
     defGridColor             = 'black'
     defGridTextColor         = "black"
  ENDELSE

  ;;color table options when values are positive or negative
  ctIndex                  = 22
  ctBrewer                 = 1
  ctReverse                = 0
  
  defLabelFormat           = '(E0.4)'
  latLabelFormat           = '(I0)'
  lonLabelFormat           = '(I0)'
  ;; integralLabelFormat      = '(D0.3)'
  dayNightIntegLabelFormat = '(F0.2)'
  fullIntegLabelFormat     = '(F0.2)'

  ;;********************
  ;;GRID DEFAULTS
  ;;********************
  defGridLineThick               = 1.0
  defGridLineThick_PS            = 2.5

  defGridBoldLineThick           = 2.0
  defGridBoldLineThick_PS        = 7

  defcharSize_grid               = 2.0

  ;;lat/lon/lshell grid defaults
  defGridLats                 = [60,70,80]
  defGridLshells              = [2,6,10,14,16,20]

  ;;the bold part
  ;; defBoldGridColor            = 'black'
  defBoldGridLinestyle        = 0
  defBoldLonDelta             = 90
  defBoldLshellDelta          = 10
  defBoldLatDelta             = 10

  ;;**********************************
  ;;Wholecap vs. not-wholecap defaults
  ;;**********************************
  ;; IF N_ELEMENTS(wholeCap) EQ 0 THEN BEGIN
  ;; IF ~KEYWORD_SET(wholeCap) THEN BEGIN
     cbPosition       = [0.10, 0.90, 0.90, 0.92]
     cbTLocation      = "TOP"
     cbVertical       = 0
     cbTCharsize      = cgDefCharsize()*1.0
     cbTextThick      = 1.5

     lTexPos1         = 0.11
     lTexPos2         = 0.68
     bTexPos1         = 0.78
     bTexPos2         = 0.74
     clockStrOffset   = -0.7

     bTexDelta        = 0.05
  ;; ENDIF ELSE BEGIN
  ;;    cbPosition       = [0.86, 0.10, 0.89, 0.90]
  ;;    cbTLocation      = "RIGHT"                     ;;"RIGHT" only works if cbVertical == 1
  ;;    cbVertical       = 1
  ;;    cbTCharsize      = defCharsize_grid
  ;;    cbTextThick      = 1.5

  ;;    lTexPos1         = 0.09
  ;;    lTexPos2         = 0.63
  ;;    bTexPos1         = 0.88
  ;;    bTexPos2         = 0.84
  ;;    clockStrOffset   = -0.8
  ;; ENDELSE

