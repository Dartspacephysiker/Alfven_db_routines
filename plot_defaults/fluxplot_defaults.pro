;; fluxPlotColorBarLabelFormat  = '(I0)'
fluxPlotColorBarLabelFormat  = '(D0.1)'
fluxPlotPPlotCBLabelFormat   = '(D0.1)'
fluxPlotEPlotCBLabelFormat   = '(D0.1)'
fluxPlotChareCBLabelFormat   = '(D0.1)'
fluxPlotChariCBLabelFormat   = '(D0.2)'

logeFluxLabels               = 1
logPFluxLabels               = 1
logiFluxLabels               = 0
logChareLabels               = 1
logChariLabels               = 1

eFlux_do_plotIntegral        = 0
PFlux_do_plotIntegral        = 0
iFlux_do_plotIntegral        = 0
Charee_do_plotIntegral       = 0
Charie_do_plotIntegral       = 0

eFlux_do_midCBLabel          = 1
PFlux_do_midCBLabel          = 1
iFlux_do_midCBLabel          = 1
Charee_do_midCBLabel         = 1
Charie_do_midCBLabel         = 1

;; energyFluxStr                = 'ergs/cm!U2!N-s'
energyFluxStr                = 'mW/m!U2!N'
numFluxStr                   = '#/cm!U2!N-s'

charEUnitString              = 'eV'

;;See JOURNAL__20151225__UNITS_OF_INTEGRATED_FLUXES.pro in Alfvendb_routines
;; intEnergyFluxStr             = 'ergs/cm-s' ;;not true, I don't think
intEnergyFluxStr             = 'mW/m' 
;; integNumFluxStr              = '#/cm-s'
integNumFluxStr              = '100/cm-s'

ionosphString                = ', at ionos.'
ionosphString_pub            = ', mapped to the ionosphere'

scAltString                  = ', at s/c alt.'
scAltString_pub              = ', at FAST altitude'


IF KEYWORD_SET(fancy_plotNames) THEN BEGIN
title__alfDB_ind_08          = 'Max Loss Cone e!U-!N Flux (' + energyFluxStr + ')' + ionosphString_pub         ;"Integ"
title__alfDB_ind_09          = 'Max e!U-!N Flux, whole dist. (' + energyFluxStr + ')' + ionosphString_pub ;"Max"
title__alfDB_ind_10          = 'Integrated Loss Cone e!U-!N Energy Flux (' + intEnergyFluxStr + ')' + ionosphString_pub      ;"Eflux_Losscone_Integ"

title__alfDB_ind_11          = 'Total Integrated e!U-!N Energy Flux (' + intEnergyFluxStr + ')' + ionosphString_pub     ;"Total_Eflux_Integ"
title__alfDB_ind_12          = 'e!U-!N Losscone Characteristic Energy (' + charEUnitString + ')'                  ;"lossCone"
title__alfDB_ind_13          = 'e!U-!N Total Characteristic Energy (' + charEUnitString + ')'                     ;"Total"
title__alfDB_esa_nFlux       = 'e!U-!N Flux (' + numFluxStr + ')' + scAltString_pub                      ;"ESA_Number_flux"


title__alfDB_ind_14          = 'Max Ion Energy Flux (' + energyFluxStr + ')' + scAltString_pub       ;"Energy"
title__alfDB_ind_15          = 'Max Ion Flux (' + numFluxStr + ')' + scAltString_pub              ;"Max" 
title__alfDB_ind_16          = 'Max Upward Ion Flux (' + numFluxStr + ')' + scAltString_pub       ;"Max_Up"

title__alfDB_ind_17          = 'Integrated Ion Flux (' + integNumFluxStr + ')' + ionosphString_pub               ;"Integ"
title__alfDB_ind_18          = 'Integrated Upward Ion Flux (' + integNumFluxStr + ')' + ionosphString_pub        ;"Integ_Up"

title__alfDB_ind_19          = 'Ion Characteristic Energy (' + charEUnitString + ')'

title__alfDB_ind_49          = 'Max Poynting Flux (' + energyFluxStr + ')' + ionosphString_pub

ENDIF ELSE BEGIN
title__alfDB_ind_08          = 'Max L.C. e!U-!N Flux (' + energyFluxStr + ')' + ionosphString         ;"Integ"
title__alfDB_ind_09          = 'Max e!U-!N Flux, whole dist. (' + energyFluxStr + ')' + ionosphString ;"Max"
title__alfDB_ind_10          = 'Integ. L.C. e!U-!N Flux (' + intEnergyFluxStr + ')' + ionosphString      ;"Eflux_Losscone_Integ"
title__alfDB_ind_11          = 'Total Integ. e!U-!N Energy Flux (' + intEnergyFluxStr + ')' + ionosphString     ;"Total_Eflux_Integ"
title__alfDB_ind_12          = 'e!U-!N Losscone Characteristic Energy (' + charEUnitString + ')'                  ;"lossCone"
title__alfDB_ind_13          = 'e!U-!N Total Characteristic Energy (' + charEUnitString + ')'                     ;"Total"
title__alfDB_esa_nFlux       = 'e!U-!N Flux (' + numFluxStr + ')' + scAltString                      ;"ESA_Number_flux"
title__alfDB_ind_14          = 'Max Ion Energy Flux (' + energyFluxStr + ')' + scAltString       ;"Energy"
title__alfDB_ind_15          = 'Max Ion Flux (' + numFluxStr + ')' + scAltString              ;"Max" 
title__alfDB_ind_16          = 'Max Upward Ion Flux (' + numFluxStr + ')' + scAltString       ;"Max_Up"
title__alfDB_ind_17          = 'Integ. Ion Flux (' + integNumFluxStr + ')' + ionosphString               ;"Integ"
title__alfDB_ind_18          = 'Integ. Upward Ion Flux (' + integNumFluxStr + ')' + ionosphString        ;"Integ_Up"
title__alfDB_ind_19          = 'Ion Characteristic Energy (' + charEUnitString + ')'
title__alfDB_ind_49          = 'Max Poynting Flux (' + energyFluxStr + ')' + ionosphString


ENDELSE


;; title__alfDB_ind_10          = 

;; use these for regexp additions: ^([[:alnum:]]+)
;; eFlux
;; PFlux
;; iFlux
;; Charee
;; Charie