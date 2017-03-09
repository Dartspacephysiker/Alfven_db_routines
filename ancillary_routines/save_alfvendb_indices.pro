PRO SAVE_ALFVENDB_INDICES, $
   alfvendb_indices_filename, $
   alfvendb_indices_filedir, $
   plot_i_list, $
   ALFDB_PLOT_STRUCT=alfDB_plot_struct, $
   ALFDB_PLOTLIM_STRUCT=alfDB_plotLim_struct, $
   IMF_STRUCT=IMF_struct, $
   MIMC_STRUCT=MIMC_struct
  
  COMPILE_OPT idl2,strictarrsubs

  ;; test = 0
  ;; STR_ELEMENT,IMF_struct,'paramString_list',test
  ;; IF SIZE(test,/TYPE) EQ 11 THEN BEGIN
  ;;    nLoops                = N_ELEMENTS(IMF_struct.paramString_list)
  ;;    use_paramString_list  = 1
  ;; ENDIF ELSE BEGIN
  ;;    nLoops                = 1
  ;;    use_paramString_list  = 0
  ;; ENDELSE

  ;; FOR k=0,nLoops-1 DO BEGIN

  saveStr               = 'save'

  ;; IF use_paramString_list THEN BEGIN
  ;;    plot_i             = plot_i_list[k]
  ;;    paramString        = IMF_struct.paramString_list[k]
  ;; ENDIF ELSE BEGIN
  ;;    plot_i             = plot_i_list
  ;;    ;; outFile         = alfvendb_indices_filename
  ;; ENDELSE
  ;; outFile               = alfvendb_indices_filename[k]

  ;;plot_i_list
  ;; IF N_ELEMENTS(plot_i_list) GT 0 THEN BEGIN
  ;;    saveStr += ',plot_i_list'
  ;; ENDIF
  ;; IF N_ELEMENTS(plot_i) GT 0 THEN BEGIN
  ;;    saveStr += ',plot_i'
  ;; ENDIF

  ;; ;;clockStr
  ;; IF N_ELEMENTS(clockStr) GT 0 THEN BEGIN
  ;;    saveStr += ',clockStr'
  ;; ENDIF

  ;; ;;angleLim1
  ;; IF N_ELEMENTS(angleLim1) GT 0 THEN BEGIN
  ;;    saveStr += ',angleLim1'
  ;; ENDIF

  ;; ;;angleLim2
  ;; IF N_ELEMENTS(angleLim2) GT 0 THEN BEGIN
  ;;    saveStr += ',angleLim2'
  ;; ENDIF

  ;; ;;orbRange
  ;; IF N_ELEMENTS(orbRange) GT 0 THEN BEGIN
  ;;    saveStr += ',orbRange'
  ;; ENDIF

  ;; ;;altitudeRange
  ;; IF N_ELEMENTS(altitudeRange) GT 0 THEN BEGIN
  ;;    saveStr += ',altitudeRange'
  ;; ENDIF

  ;; ;;charERange
  ;; IF N_ELEMENTS(charERange) GT 0 THEN BEGIN
  ;;    saveStr += ',charERange'
  ;; ENDIF

  ;; ;;charE__Newell_the_cusp
  ;; IF N_ELEMENTS(charE__Newell_the_cusp) GT 0 THEN BEGIN
  ;;    saveStr += ',charE__Newell_the_cusp'
  ;; ENDIF

  ;; ;;minM
  ;; IF N_ELEMENTS(minM) GT 0 THEN BEGIN
  ;;    saveStr += ',minM'
  ;; ENDIF

  ;; ;;maxM
  ;; IF N_ELEMENTS(maxM) GT 0 THEN BEGIN
  ;;    saveStr += ',maxM'
  ;; ENDIF

  ;; ;;binM
  ;; IF N_ELEMENTS(binM) GT 0 THEN BEGIN
  ;;    saveStr += ',binM'
  ;; ENDIF

  ;; ;;shiftM
  ;; IF N_ELEMENTS(shiftM) GT 0 THEN BEGIN
  ;;    saveStr += ',shiftM'
  ;; ENDIF

  ;; ;;minI
  ;; IF N_ELEMENTS(minI) GT 0 THEN BEGIN
  ;;    saveStr += ',minI'
  ;; ENDIF

  ;; ;;maxI
  ;; IF N_ELEMENTS(maxI) GT 0 THEN BEGIN
  ;;    saveStr += ',maxI'
  ;; ENDIF

  ;; ;;binI
  ;; IF N_ELEMENTS(binI) GT 0 THEN BEGIN
  ;;    saveStr += ',binI'
  ;; ENDIF

  ;; ;;EA_binning
  ;; IF N_ELEMENTS(EA_binning) GT 0 THEN BEGIN
  ;;    saveStr += ',EA_binning'
  ;; ENDIF

  ;; ;;do_lShell
  ;; IF N_ELEMENTS(do_lShell) GT 0 THEN BEGIN
  ;;    saveStr += ',do_lShell'
  ;; ENDIF

  ;; ;;minL
  ;; IF N_ELEMENTS(minL) GT 0 THEN BEGIN
  ;;    saveStr += ',minL'
  ;; ENDIF

  ;; ;;maxL
  ;; IF N_ELEMENTS(maxL) GT 0 THEN BEGIN
  ;;    saveStr += ',maxL'
  ;; ENDIF

  ;; ;;binL
  ;; IF N_ELEMENTS(binL) GT 0 THEN BEGIN
  ;;    saveStr += ',binL'
  ;; ENDIF

  ;; ;;minMC
  ;; IF N_ELEMENTS(minMC) GT 0 THEN BEGIN
  ;;    saveStr += ',minMC'
  ;; ENDIF

  ;; ;;maxNegMC
  ;; IF N_ELEMENTS(maxNegMC) GT 0 THEN BEGIN
  ;;    saveStr += ',maxNegMC'
  ;; ENDIF

  ;; ;;HwMAurOval
  ;; IF N_ELEMENTS(HwMAurOval) GT 0 THEN BEGIN
  ;;    SaveStr += ',HwMAurOval'
  ;; ENDIF

  ;; ;;HwMKpInd
  ;; IF N_ELEMENTS(HwMKpInd) GT 0 THEN BEGIN
  ;;    SaveStr += ',HwMKpInd'
  ;; ENDIF

  ;; ;;byMin
  ;; IF N_ELEMENTS(byMin) GT 0 THEN BEGIN
  ;;    saveStr += ',byMin'
  ;; ENDIF

  ;; ;;byMax
  ;; IF N_ELEMENTS(byMax) GT 0 THEN BEGIN
  ;;    saveStr += ',byMax'
  ;; ENDIF

  ;; ;;bzMin
  ;; IF N_ELEMENTS(bzMin) GT 0 THEN BEGIN
  ;;    saveStr += ',bzMin'
  ;; ENDIF

  ;; ;;bzMax
  ;; IF N_ELEMENTS(bzMax) GT 0 THEN BEGIN
  ;;    saveStr += ',bzMax'
  ;; ENDIF

  ;; ;;btMin
  ;; IF N_ELEMENTS(btMin) GT 0 THEN BEGIN
  ;;    saveStr += ',btMin'
  ;; ENDIF

  ;; ;;btMax
  ;; IF N_ELEMENTS(btMax) GT 0 THEN BEGIN
  ;;    saveStr += ',btMax'
  ;; ENDIF

  ;; ;;bxMin
  ;; IF N_ELEMENTS(bxMin) GT 0 THEN BEGIN
  ;;    saveStr += ',bxMin'
  ;; ENDIF

  ;; ;;bxMax
  ;; IF N_ELEMENTS(bxMax) GT 0 THEN BEGIN
  ;;    saveStr += ',bxMax'
  ;; ENDIF

  ;; ;;abs_byMin
  ;; IF N_ELEMENTS(abs_byMin) GT 0 THEN BEGIN
  ;;    saveStr += ',abs_byMin'
  ;; ENDIF

  ;; ;;abs_byMax
  ;; IF N_ELEMENTS(abs_byMax) GT 0 THEN BEGIN
  ;;    saveStr += ',abs_byMax'
  ;; ENDIF

  ;; ;;abs_bzMin
  ;; IF N_ELEMENTS(abs_bzMin) GT 0 THEN BEGIN
  ;;    saveStr += ',abs_bzMin'
  ;; ENDIF

  ;; ;;abs_bzMax
  ;; IF N_ELEMENTS(abs_bzMax) GT 0 THEN BEGIN
  ;;    saveStr += ',abs_bzMax'
  ;; ENDIF

  ;; ;;abs_btMin
  ;; IF N_ELEMENTS(abs_btMin) GT 0 THEN BEGIN
  ;;    saveStr += ',abs_btMin'
  ;; ENDIF

  ;; ;;abs_btMax
  ;; IF N_ELEMENTS(abs_btMax) GT 0 THEN BEGIN
  ;;    saveStr += ',abs_btMax'
  ;; ENDIF

  ;; ;;abs_bxMin
  ;; IF N_ELEMENTS(abs_bxMin) GT 0 THEN BEGIN
  ;;    saveStr += ',abs_bxMin'
  ;; ENDIF

  ;; ;;abs_bxMax
  ;; IF N_ELEMENTS(abs_bxMax) GT 0 THEN BEGIN
  ;;    saveStr += ',abs_bxMax'
  ;; ENDIF

  ;; ;;Bx_over_ByBz_Lim
  ;; IF N_ELEMENTS(Bx_over_ByBz_Lim) GT 0 THEN BEGIN
  ;;    saveStr += ',Bx_over_ByBz_Lim'
  ;; ENDIF

  ;; ;;paramString
  ;; IF N_ELEMENTS(paramString) GT 0 THEN BEGIN
  ;;    saveStr += ',paramString'
  ;; ENDIF

  ;; ;;paramString_list
  ;; ;; IF N_ELEMENTS(paramString_list) GT 0 THEN BEGIN
  ;; ;;    saveStr += ',paramString_list'
  ;; ;; ENDIF

  ;; ;;plotPrefix
  ;; IF N_ELEMENTS(plotPrefix) GT 0 THEN BEGIN
  ;;    saveStr += ',plotPrefix'
  ;; ENDIF

  ;; ;;plotSuffix
  ;; IF N_ELEMENTS(plotSuffix) GT 0 THEN BEGIN
  ;;    saveStr += ',plotSuffix'
  ;; ENDIF

  ;; ;;satellite
  ;; IF N_ELEMENTS(satellite) GT 0 THEN BEGIN
  ;;    saveStr += ',satellite'
  ;; ENDIF

  ;; ;;omni_Coords
  ;; IF N_ELEMENTS(omni_Coords) GT 0 THEN BEGIN
  ;;    saveStr += ',omni_Coords'
  ;; ENDIF

  ;; ;;hemi
  ;; IF N_ELEMENTS(hemi) GT 0 THEN BEGIN
  ;;    saveStr += ',hemi'
  ;; ENDIF

  ;; ;;delay
  ;; IF N_ELEMENTS(delay) GT 0 THEN BEGIN
  ;;    saveStr += ',delay'
  ;; ENDIF

  ;; ;;multiple_delays
  ;; IF N_ELEMENTS(multiple_delays) GT 0 THEN BEGIN
  ;;    saveStr += ',multiple_delays'
  ;; ENDIF

  ;; ;;multiple_IMF_clockAngles
  ;; IF N_ELEMENTS(multiple_IMF_clockAngles) GT 0 THEN BEGIN
  ;;    saveStr += ',multiple_IMF_clockAngles'
  ;; ENDIF

  ;; ;;stableIMF
  ;; IF N_ELEMENTS(stableIMF) GT 0 THEN BEGIN
  ;;    saveStr += ',stableIMF'
  ;; ENDIF

  ;; ;;smoothWindow
  ;; IF N_ELEMENTS(smoothWindow) GT 0 THEN BEGIN
  ;;    saveStr += ',smoothWindow'
  ;; ENDIF

  ;; ;;includeNoConsecData
  ;; IF N_ELEMENTS(includeNoConsecData) GT 0 THEN BEGIN
  ;;    saveStr += ',includeNoConsecData'
  ;; ENDIF

  ;; ;;hoyDia
  ;; IF N_ELEMENTS(hoyDia) GT 0 THEN BEGIN
  ;;    saveStr += ',hoyDia'
  ;; ENDIF

  ;; ;;maskMin
  ;; IF N_ELEMENTS(maskMin) GT 0 THEN BEGIN
  ;;    saveStr += ',maskMin'
  ;; ENDIF

  IF N_ELEMENTS(IMF_struct) GT 0 THEN BEGIN
     saveStr += ',IMF_struct'
  ENDIF

  IF N_ELEMENTS(MIMC_struct) GT 0 THEN BEGIN
     saveStr += ',MIMC_struct'
  ENDIF

  IF N_ELEMENTS(alfDB_plot_struct) GT 0 THEN BEGIN
     saveStr += ',alfDB_plot_struct'
  ENDIF

  IF N_ELEMENTS(alfDB_plotLim_struct) GT 0 THEN BEGIN
     saveStr += ',alfDB_plotLim_struct'
  ENDIF

  saveStr    += ',FILENAME=alfvendb_indices_filedir+outFile'

  PRINT,'Saving AlfvenDB indices to ' + outFile + '...'
  success               = EXECUTE(saveStr)

  IF ~success THEN PRINT,'ERROR occurred while attempting to save AlfvenDB indices...'

  ;; ENDFOR

END