;; fluxPlotColorBarLabelFormat  = '(I0)'
fluxPlotColorBarLabelFormat  = '(D0.2)'
fluxPlotPPlotCBLabelFormat   = '(D0.2)'
fluxPlotEPlotCBLabelFormat   = '(G0.2)'
fluxPlotChareCBLabelFormat   = '(D0.1)'
fluxPlotCharieCBLabelFormat  = '(D0.2)'
fluxPlotMagCCBLabelFormat  = '(D0.2)'

logeFluxLabels               = 0
logeNumFluxLabels            = 0
logPFluxLabels               = 0
logiFluxLabels               = 0
logChareLabels               = 0
logCharieLabels              = 0
logMagCLabels              = 0

eFlux_do_plotIntegral        = 0
eNumFlux_do_plotIntegral     = 0
PFlux_do_plotIntegral        = 0
iFlux_do_plotIntegral        = 0
Charee_do_plotIntegral       = 0
Charie_do_plotIntegral       = 0
MagC_do_plotIntegral       = 0

eFlux_do_midCBLabel          = 1
eNumFlux_do_midCBLabel       = 1
PFlux_do_midCBLabel          = 1
iFlux_do_midCBLabel          = 1
Charee_do_midCBLabel         = 1
Charie_do_midCBLabel         = 1
MagC_do_midCBLabel         = 1

;; energyFluxStr                = 'ergs/cm!U2!N-s'
energyFluxStr                = 'mW m!U-2!N'
numFluxStr                   = '# cm!U-2!Ns!U-1!N'

energyGrossStr                = 'W'
numGrossStr                   = '#/s'

charEUnitString              = 'eV'

;;See JOURNAL__20151225__UNITS_OF_INTEGRATED_FLUXES.pro in Alfvendb_routines
;; intEnergyFluxStr             = 'ergs/cm-s' ;;not true, I don't think
intEnergyFluxStr             = 'mW m!U-1!N' 
;; integNumFluxStr              = '#/cm-s'
;; integNumFluxStr              = '100/cm-s'
integNumFluxStr              = '# cm!U-1!Ns!U-1!N'

;; ionosphString                = ', at ionos.'
ionosphString                = ' at 100 km'
ionosphString_pub            = ', mapped to the ionosphere'

scAltString                  = ', at s/c alt.'
scAltString_pub              = ', at FAST altitude'

;; IF KEYWORD_SET(fancy_plotNames) THEN BEGIN
;;    scString                     = scAltString_pub
;;    ionosString                  = ionosphString_pub
;; ENDIF

IF KEYWORD_SET(fancy_plotNames) THEN BEGIN
title__alfDB_ind_06          = 'Mag Current (microA/m!U2!N)' + scAltString_pub
title__alfDB_ind_07          = 'ESA Current (microA/m!U2!N)' + ionosphString_pub    ;"ESA_CURRENT"
title__alfDB_ind_08          = 'Max Loss-cone e!U-!N Flux (' + energyFluxStr + ')' + ionosphString_pub    ;"Max"     
title__alfDB_ind_09          = 'Max e!U-!N Flux, whole dist. (' + energyFluxStr + ')' + ionosphString_pub ;"Integ"
title__alfDB_ind_10          = 'Integrated Loss Cone e!U-!N Energy Flux (' + intEnergyFluxStr + ')' + ionosphString_pub      ;"Eflux_Losscone_Integ"

title__alfDB_ind_11          = 'Total Integrated e!U-!N Energy Flux (' + intEnergyFluxStr + ')' + ionosphString_pub     ;"Total_Eflux_Integ"
title__alfDB_ind_12          = 'e!U-!N Losscone Characteristic Energy (' + charEUnitString + ')'                  ;"lossCone"
title__alfDB_ind_13          = 'e!U-!N Total Characteristic Energy (' + charEUnitString + ')'                     ;"Total"
title__alfDB_esa_nFlux       = 'e!U-!N Flux (' + numFluxStr + ')' + ionosphString_pub                      ;"ESA_Number_flux"


;; title__alfDB_ind_14          = 'Max Ion Energy Flux (' + energyFluxStr + ')' + scAltString_pub       ;"Energy"
;; title__alfDB_ind_15          = 'Max Ion Flux (' + numFluxStr + ')' + scAltString_pub              ;"Max" 
;; title__alfDB_ind_16          = 'Max Upward Ion Flux (' + numFluxStr + ')' + scAltString_pub       ;"Max_Up"

;;mapping these to ionos as of 2016/01/27
title__alfDB_ind_14          = 'Max Ion Energy Flux (' + energyFluxStr + ')' + ionosphString_pub       ;"Energy"
title__alfDB_ind_15          = 'Max Ion Flux (' + numFluxStr + ')' + ionosphString_pub              ;"Max" 
title__alfDB_ind_16          = 'Max Upward Ion Flux (' + numFluxStr + ')' + ionosphString_pub       ;"Max_Up"

title__alfDB_ind_17          = 'Integrated Ion Flux (' + integNumFluxStr + ')' + ionosphString_pub               ;"Integ"
title__alfDB_ind_18          = 'Integrated Upward Ion Flux (' + integNumFluxStr + ')' + ionosphString_pub        ;"Integ_Up"

title__alfDB_ind_19          = 'Ion Characteristic Energy (' + charEUnitString + ')'

;; title__alfDB_ind_26          = 'Max Upward H+ Flux (' + numFluxStr + ')' + scAltString_pub       ;"Max_Up"
;; title__alfDB_ind_27          = 'H+ Characteristic Energy (' + charEUnitString + ')' + scAltString_pub       ;"Max_Up"
;; title__alfDB_ind_28          = 'Max Upward O+ Flux (' + numFluxStr + ')' + scAltString_pub       ;"Max_Up"
;; title__alfDB_ind_29          = 'O+ Characteristic Energy (' + charEUnitString + ')' + scAltString_pub       ;"Max_Up"
;; title__alfDB_ind_30          = 'Max Upward He+ Flux (' + numFluxStr + ')' + scAltString_pub       ;"Max_Up"
;; title__alfDB_ind_31          = 'He+ Characteristic Energy (' + charEUnitString + ')' + scAltString_pub       ;"Max_Up"

title__alfDB_ind_26          = 'Max Upward H+ Flux (' + numFluxStr + ')' + ionosphString_pub       ;"Max_Up"
title__alfDB_ind_27          = 'H+ Characteristic Energy (' + charEUnitString + ')' + scAltString_pub       ;"Max_Up"
title__alfDB_ind_28          = 'Max Upward O+ Flux (' + numFluxStr + ')' + ionosphString_pub       ;"Max_Up"
title__alfDB_ind_29          = 'O+ Characteristic Energy (' + charEUnitString + ')' + scAltString_pub       ;"Max_Up"
title__alfDB_ind_30          = 'Max Upward He+ Flux (' + numFluxStr + ')' + ionosphString_pub       ;"Max_Up"
title__alfDB_ind_31          = 'He+ Characteristic Energy (' + charEUnitString + ')' + scAltString_pub       ;"Max_Up"

;; title__alfDB_ind_49          = 'Max Poynting Flux (' + energyFluxStr + ')' + ionosphString_pub
title__alfDB_ind_49          = 'Log-averaged Poynting Flux (' + energyFluxStr + ')' + ionosphString_pub

ENDIF ELSE BEGIN

title__alfDB_ind_06          = 'Mag Current (microA/m!U2!N)' + scAltString_pub
title__alfDB_ind_07          = 'ESA Current ( microA/m!U2!N)' + ionosphString    ;"ESA_CURRENT"     
title__alfDB_ind_08          = 'Max L.C. e!U-!N Flux (' + energyFluxStr + ')' + ionosphString         ;"Integ"
title__alfDB_ind_09          = 'Max e!U-!N Flux, whole dist. (' + energyFluxStr + ')' + ionosphString ;"Max"
title__alfDB_ind_10          = 'Integ. L.C. e!U-!N Flux (' + intEnergyFluxStr + ')' + ionosphString      ;"Eflux_Losscone_Integ"
title__alfDB_ind_11          = 'Total Integ. e!U-!N Energy Flux (' + intEnergyFluxStr + ')' + ionosphString     ;"Total_Eflux_Integ"
title__alfDB_ind_12          = 'e!U-!N Losscone Characteristic Energy (' + charEUnitString + ')'                  ;"lossCone"
title__alfDB_ind_13          = 'e!U-!N Total Characteristic Energy (' + charEUnitString + ')'                     ;"Total"
title__alfDB_esa_nFlux       = 'e!U-!N Flux (' + numFluxStr + ')' + ionosphString                      ;"ESA_Number_flux"
title__alfDB_ind_14          = 'Max Ion Energy Flux (' + energyFluxStr + ')' + ionosphString       ;"Energy"
title__alfDB_ind_15          = 'Max Ion Flux (' + numFluxStr + ')' + ionosphString              ;"Max" 
title__alfDB_ind_16          = 'Max Upward Ion Flux (' + numFluxStr + ')' + ionosphString       ;"Max_Up"
title__alfDB_ind_17          = 'Integ. Ion Flux (' + integNumFluxStr + ')' + ionosphString               ;"Integ"
title__alfDB_ind_18          = 'Integ. Upward Ion Flux (' + integNumFluxStr + ')' + ionosphString        ;"Integ_Up"
Title__alfDB_ind_19          = 'Ion Characteristic Energy (' + charEUnitString + ')'
title__alfDB_ind_26          = 'Max Upward H+ Flux (' + numFluxStr + ')' + ionosphString       ;"Max_Up"
title__alfDB_ind_27          = 'H+ Characteristic Energy (' + charEUnitString + ')' + scAltString       ;"Max_Up"
title__alfDB_ind_28          = 'Max Upward O+ Flux (' + numFluxStr + ')' + ionosphString       ;"Max_Up"
title__alfDB_ind_29          = 'O+ Characteristic Energy (' + charEUnitString + ')' + scAltString       ;"Max_Up"
title__alfDB_ind_30          = 'Max Upward He+ Flux (' + numFluxStr + ')' + ionosphString       ;"Max_Up"
title__alfDB_ind_31          = 'He+ Characteristic Energy (' + charEUnitString + ')' + scAltString       ;"Max_Up"

;; title__alfDB_ind_49          = 'Log-averaged Poynting Flux (' + energyFluxStr + ')' + ionosphString
title__alfDB_ind_49          = 'Poynting Flux (' + energyFluxStr + ')' + ionosphString

ENDELSE

;;For time-averaged storm plots
title__alfDB_ind_10_tAvg     = 'Loss-cone e!U-!N Flux (' + energyFluxStr + ')' + ionosphString      ;"Eflux_Losscone_Integ"
title__alfDB_ind_18_tAvg     = 'Upward Ion Flux (' + numFluxStr + ')' + ionosphString        ;"Integ_Up"
title__alfDB_ind_49_tAvg     = 'Time-averaged Poynting Flux (' + energyFluxStr + ')' + ionosphString

;;Integrated Poynting flux
title__alfDB_ind_49_integ    = 'Integ. Poynting Flux (' + intEnergyFluxStr + ')' + ionosphString

;;Integrated e- number flux
title__alfDB_esa_nFlux_integ = 'Integ. e!U-!N Flux (' + intEnergyFluxStr + ')' + ionosphString

;;Gross rates
;; title__alfDB_esa_nFlux_grossRate = 'e!U-!N Number Deposition (' + numGrossStr + ')' + ionosphString                      ;"ESA_Number_flux"
title__alfDB_esa_nFlux_grossRate = 'e!U-!N Precipitation (' + numGrossStr + ')' + ionosphString                      ;"ESA_Number_flux"
title__alfDB_ind_08_grossRate = 'Max e!U-!N Energy Deposition (' + energyGrossStr + ')' + ionosphString      ;"Eflux_Losscone_Integ"
title__alfDB_ind_10_grossRate = 'e!U-!N Energy Deposition (' + energyGrossStr + ')' + ionosphString      ;"Eflux_Losscone_Integ"
title__alfDB_ind_11_grossRate = 'Total Alfic e!U-!N Energy Deposition (' + energyGrossStr + ')' + ionosphString      ;"Eflux_Losscone_Integ"
title__alfDB_ind_18_grossRate = 'All Ions (' + numGrossStr + ')' + ionosphString        ;"Integ"
title__alfDB_ind_18_grossRate = 'Upflowing Ions (' + numGrossStr + ')' + ionosphString        ;"Integ_Up"
title__alfDB_ind_49_grossRate = 'Wave Energy Deposition  (' + energyGrossStr + ')' + ionosphString

;;Divided by width_x
title__alfDB_ind_10__div_by_width_x  = 'Loss-cone e!U-!N Flux (' + energyFluxStr + ')' + ionosphString      ;"Eflux_Losscone_Integ"
title__alfDB_ind_11__div_by_width_x  = 'Total e!U-!N Energy Flux (' + energyFluxStr + ')' + ionosphString     ;"Total_Eflux_Integ"
title__alfDB_ind_17__div_by_width_x  = 'Ion Flux (' + numFluxStr + ')' + ionosphString               ;"Integ"
title__alfDB_ind_18__div_by_width_x  = 'Upward Ion Flux (' + numFluxStr + ')' + ionosphString        ;"Integ_Up"

;; title__alfDB_ind_10          = 

;;For storm paper
alficStr                             = ANSI_VALUE('Alfvénic')
;; alficStr                             = ''

title__alfDB_ind_10__div_by_width_x  = alficStr + ' Loss-cone e!U-!N Flux (' + energyFluxStr + ')' + ionosphString ;"Eflux_Losscone_Integ"
title__alfDB_ind_18__div_by_width_x  = alficStr + ' Upward Ion Flux (' + numFluxStr + ')' + ionosphString          ;"Integ_Up"
title__alfDB_ind_49                  = alficStr + ' Poynting Flux (' + energyFluxStr + ')' + ionosphString

title__eSpec_ind_10     = 'Non-' + alficStr + ' Loss-cone e!U-!N Flux (' + energyFluxStr + ')' + ionosphString ;"Eflux_Losscone_Integ"
title__eSpec_esa_nFlux  = 'Non-' + alficStr + ' Loss-cone e!U-!N Flux (' + numFluxStr + ')' + ionosphString    ;"ESA_Number_flux"
title__eSpec_ind_18     = 'Non-' + alficStr + ' Upward Ion Flux (' + numFluxStr + ')' + ionosphString          ;"Integ_Up"
title__eSpec_ion_energy = 'Non-' + alficStr + ' Upward Ion Energy Flux (' + numFluxStr + ')' + ionosphString   ;Specialty

title__eSpec_charEE                = 'Electron Characteristic Energy (' + charEUnitString + ') ' + scAltString

;;The eSpec guys
title__eSpec_ind_10__grossRate = 'e!U-!N Energy Deposition, every type (' + energyGrossStr + ')' + ionosphString      ;"for_eSpec eSpec stuff
title__eSpec_esa_nFlux__grossRate = ' Loss-cone e!U-!N Flux (' + numGrossStr + ')' + ionosphString    ;"ESA_Number_flux"
title__eSpec_ind_18__grossRate = ' Upward Ion Flux (' + numGrossStr + ')' + ionosphString          ;"Integ_Up"


;; use these for regexp additions: ^([[:alnum:]]+)
;; eFlux
;; PFlux
;; iFlux
;; Charee
;; Charie