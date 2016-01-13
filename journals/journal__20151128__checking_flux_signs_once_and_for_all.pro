;20151128
;There has been far too much confusion with regard to what the flux values and integrated
;flux values are. This information helps to settle the matter, and the text file
;"20151127--why_flux_is_so_weird_in_Alfven_DB.txt" contains the detailed info
PRO JOURNAL__20151128__CHECKING_FLUX_SIGNS_ONCE_AND_FOR_ALL

  load_maximus_and_cdbtime,maximus,CORRECT_FLUXES=0
  maxTags = TAG_NAMES(maximus)

  gi_n=GET_CHASTON_IND(maximus,/NORTH)
  gi_s=GET_CHASTON_IND(maximus,/SOUTH)

  ;;quantities of interest:
  ;;for i=0,20 DO PRINT,i,(tag_names(maximus))[i]
  ;;7, ESA_CURRENT
  ;;8, ELEC_ENERGY_FLUX
  ;;9, INTEG_ELEC_ENERGY_FLUX
  ;;10, EFLUX_LOSSCONE_INTEG
  ;;11, TOTAL_EFLUX_INTEG
  ;;12, MAX_CHARE_LOSSCONE
  ;;13, MAX_CHARE_TOTAL
  ;;14, ION_ENERGY_FLUX
  ;;15, ION_FLUX
  ;;16, ION_FLUX_UP
  ;;17, INTEG_ION_FLUX
  ;;18, INTEG_ION_FLUX_UP
  ;;19, CHAR_ION_ENERGY
  
  quants = [7, $                ;e- number flux (current)
            8,9, $              ;e- energy fluxes
            10,11, $            ;e- integrated energy fluxes
            12,13, $            ;e- char energies
            14, $               ;ion energy flux
            15,16, $            ;ion max number fluxes
            17,18, $            ;integrated ion number fluxes
            19]

  FOR i=0,N_ELEMENTS(quants)-1 DO BEGIN
     max_i     = quants[i]          ;Index of the quantity in the maximus DB
     
     ;;Get the numbers
     nPosNorth = N_ELEMENTS(WHERE(maximus.(max_i)[gi_n] GT 0,/NULL))
     nNegNorth = N_ELEMENTS(WHERE(maximus.(max_i)[gi_n] LT 0,/NULL))

     nPosSouth = N_ELEMENTS(WHERE(maximus.(max_i)[gi_s] GT 0,/NULL))
     nNegSouth = N_ELEMENTS(WHERE(maximus.(max_i)[gi_s] LT 0,/NULL))

     ;;Print it out
     PRINT,"********************"
     PRINT,maxTags[max_i]
     PRINT,"********************"
     PRINT,">>Hemisphere  : Northern"
     PRINT,FORMAT='(">>>N positive :",T18,I0)',nPosNorth
     PRINT,FORMAT='(">>>N negative :",T18,I0)',nNegNorth
     PRINT,''
     PRINT,">>Hemisphere  : Southern"
     PRINT,FORMAT='(">>>N positive :",T18,I0)',nPosSouth
     PRINT,FORMAT='(">>>N negative :",T18,I0)',nNegSouth

  ENDFOR

END
