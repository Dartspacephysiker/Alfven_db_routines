;+
; NAME:    SET_UTC_PARAMS_AND_IND_DEFAULTS
;
; PURPOSE: For the love, it is high time to consolidate like thirty different codes all doing the same thing a little differently
;
; CALLING SEQUENCE: 
;
; INPUTS:
;
; OPTIONAL INPUTS:   
;                *DATABASE PARAMETERS
;		     ORBRANGE          :  Two-element vector, lower and upper limit on orbits to include   
;		     ALTITUDERANGE     :  Two-element vector, lower and upper limit on altitudes to include   
;                    CHARERANGE        :  Two-element vector, lower ahd upper limit on characteristic energy of electrons in 
;                                            the LOSSCONE (could change it to total in get_chaston_ind.pro).
;                    POYNTRANGE        :  Two-element vector, lower and upper limit Range of Poynting flux values to include.
; 		     MINMLT            :  MLT min  (Default: 9)
; 		     MAXMLT            :  MLT max  (Default: 15)
; 		     BINMLT            :  MLT binsize  (Default: 0.5)
;		     MINILAT           :  ILAT min (Default: 64)
;		     MAXILAT           :  ILAT max (Default: 80)
;		     BINILAT           :  ILAT binsize (Default: 2.0)
;
;                *HOLZWORTH/MENG STATISTICAL AURORAL OVAL PARAMETERS 
;                    HWMAUROVAL        :  Only include those data that are above the statistical auroral oval.
;                    HWMKPIND          :  Kp Index to use for determining the statistical auroral oval (def: 7)
;
;
; KEYWORD PARAMETERS:
;
; OUTPUTS:
;
; OPTIONAL OUTPUTS: 
;                    MAXIMUS           :  Return maximus structure used in this pro.
;
; PROCEDURE:
;
; EXAMPLE: 
;
; MODIFICATION HISTORY: Best to follow my mod history on the Github repository...
;                       
;                       2015/10/21 : This pro was born while making that newfangled utc plotter deal
;                       
;-
PRO SET_UTCPLOT_PARAMS_AND_IND_DEFAULTS,ORBRANGE=orbRange, ALTITUDERANGE=altitudeRange, CHARERANGE=charERange, $
                                    PARAMSTRING=paramString, $
                                    LUN=lun

  COMPILE_OPT idl2
  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout
  ;;***********************************************
  ;;You know
  
  defOrbRange            = [0,16361]
  defCharERange          = [4.0,3e4]
  defAltRange            = [000.0, 5000.0]

  defParamString         = "user-specified_UTCRange"

  ;;***********************************************
  ;;RESTRICTIONS ON DATA, SOME VARIABLES
  IF N_ELEMENTS(orbRange) EQ 0 THEN orbRange = defOrbRange         ; 4,~300 eV in Strangeway

  IF N_ELEMENTS(charERange) EQ 0 THEN charERange = defCharERange         ; 4,~300 eV in Strangeway

  IF N_ELEMENTS(altitudeRange) EQ 0 THEN altitudeRange = defAltRange ;Rob Pfaff says no lower than 1000m
  
  IF N_ELEMENTS(paramString) EQ 0 THEN paramString = defParamString 

END