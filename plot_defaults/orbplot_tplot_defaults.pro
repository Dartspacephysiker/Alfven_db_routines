defProbOccurrenceCBLabelFormat        = '(D0.3)'
defProbOccurrenceLogLabels            = 1
defProbOccurrence_do_midCBLabel       = 1

defProbOccurrence_doPlotIntegral      = 0


defTHistDenomPlotTitle                = 'FAST ephemeris histogram (min)'
defTHistDenomNormedPlotTitle          = 'FAST ephemeris histogram' ;rest added by GET_TIMEHIST routine
defTHistDenomCBLabelFormat            = '(G0.3)'
defTHistDenomLogLabels                = 1
defTHistDenom_do_midCBLabel           = 1
defTHistDenom_doPlotIntegral          = 0

Deftimeavgd_PFluxCBLabelFormat        = '(D0.3)'
defTimeAvgd_PFluxLogLabels            = 0
defTimeAvgd_PFlux_do_midCBLabel       = 1

defTimeAvgd_PFlux_doPlotIntegral      = 0

defTimeAvgd_eFluxMaxCBLabelFormat     = '(D0.3)'
defTimeAvgd_eFluxMaxLogLabels         = 0
defTimeAvgd_eFluxMax_do_midCBLabel    = 1

defTimeAvgd_eFluxMax_doPlotIntegral   = 0


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



title__probOccurrence        = "Probability of occurrence"
name__probOccurrence         = "probOccurrence"

;; title__timeAvgd_pFlux        = 'Time-averaged Poynting flux (' + energyFluxStr + ')' + ionosphString_pub
title__timeAvgd_pFlux        = 'Time-averaged Poynting flux (' + energyFluxStr + ')'
name__timeAvgd_pFlux         = "timeAvgd_pFlux"

;; title__timeAvgd_eFluxMax     = 'Time-averaged loss-cone e!U-!N flux (' + energyFluxStr + ')' + ionosphString_pub
title__timeAvgd_eFluxMax     = 'Time-averaged loss-cone e!U-!N flux (' + energyFluxStr + ')'
name__timeAvgd_eFluxMax      = "timeAvgd_eFluxMax"