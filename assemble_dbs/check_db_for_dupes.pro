;2016/01/08
;This despun database is bound to have a mountain of duplicates in orbits, so now I get to figure that out.
;The especially tricky thing is that we've got to figure out which ones don't have zero integrals (or possibly NaNs)
; associated with them.
PRO CHECK_DB_FOR_DUPES,cdbTime,out_dupe_i, $
                       LUN=lun

  COMPILE_OPT idl2

  IF N_ELEMENTS(lun) EQ 0 THEN lun=-1 ;stdout

  PRINTF,lun,"Checking duplicates in this mah'mus database!"
  
  CHECK_DUPES,cdbTime,rev_ind,dupes_rev_ind,dataenum, $
              OUT_DUPE_I=out_dupe_i, $
              PRINTDUPES=printDupes



END