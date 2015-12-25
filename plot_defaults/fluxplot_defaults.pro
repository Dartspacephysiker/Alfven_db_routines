fluxPlotColorBarLabelFormat  = '(D0.2)'
fluxPlotChareCBLabelFormat   = '(D0.1)'
fluxPlotChariCBLabelFormat   = '(D0.2)'

logeFluxLabels               = 1
logPFluxLabels               = 1
logiFluxLabels               = 0
logChareLabels               = 0
logChariLabels               = 1

eFlux_do_plotIntegral        = 0
PFlux_do_plotIntegral        = 0
iFlux_do_plotIntegral        = 0
Charee_do_plotIntegral       = 0
Charie_do_plotIntegral       = 0

eFlux_do_midCBLabel          = 0
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

;;get_eFlux
;; title__alfDB_ind_08          = '08-Max L.C. e- Flux (' + energyFluxStr + '), at ionos.'         ;"Integ"
title__alfDB_ind_08          = 'Max L.C. e- Flux (' + energyFluxStr + '), at ionos.'         ;"Integ"
;; title__alfDB_ind_09          = '09-Max e- Flux, whole dist. (' + energyFluxStr + '), at ionos.' ;"Max"
title__alfDB_ind_09          = 'Max e- Flux, whole dist. (' + energyFluxStr + '), at ionos.' ;"Max"
;get_eNumFlux
;;title__alfDB_ind_10          = '10-Integ. L.C. e- Flux (' + energyFluxStr + '), at ionos.'      ;"Eflux_Losscone_Integ"
title__alfDB_ind_10          = 'Integ. L.C. e- Flux (' + intEnergyFluxStr + '), at ionos.'      ;"Eflux_Losscone_Integ"
;; title__alfDB_ind_11          = '11-Total Integ. e- Flux (' + energyFluxStr + '), at ionos.'     ;"Total_Eflux_Integ"
title__alfDB_ind_11          = 'Total Integ. e- Flux (' + intEnergyFluxStr + '), at ionos.'     ;"Total_Eflux_Integ"
;get_ChareE
title__alfDB_ind_12          = 'e- Losscone Characteristic Energy (' + charEUnitString + ')'                  ;"lossCone"
title__alfDB_ind_13          = 'e- Total Characteristic Energy (' + charEUnitString + ')'                     ;"Total"
title__alfDB_esa_nFlux       = 'e- Flux (' + numFluxStr + '), at s/c alt.'                      ;"ESA_Number_flux"
;get_
title__alfDB_ind_14          = 'Max Ion Energy Flux (' + energyFluxStr + '), s/c alt.'       ;"Energy"
title__alfDB_ind_15          = 'Max Ion Flux (' + numFluxStr + '), at s/c alt.'              ;"Max" 
title__alfDB_ind_16          = 'Max Upward Ion Flux (' + numFluxStr + '), at s/c alt.'       ;"Max_Up"
title__alfDB_ind_17          = 'Integ. Ion Flux (' + integNumFluxStr + '), at ionos.'               ;"Integ"
;; title__alfDB_ind_18          = '18-Integ. Upward Ion Flux (' + numFluxStr + '), at ionos.'        ;"Integ_Up"
title__alfDB_ind_18          = 'Integ. Upward Ion Flux (' + integNumFluxStr + '), at ionos.'        ;"Integ_Up"
;get_ChariE
title__alfDB_ind_19          = 'Ion Characteristic Energy (' + charEUnitString + ')'
;get_pFlux
title__alfDB_ind_49          = 'Max Poynting Flux (' + energyFluxStr + '), at ionos.'
;; title__alfDB_ind_10          = 
;; title__alfDB_ind_10          = 
;; title__alfDB_ind_10          = 

;; use these for regexp additions: ^([[:alnum:]]+)
;; eFlux
;; PFlux
;; iFlux
;; Charee
;; Charie