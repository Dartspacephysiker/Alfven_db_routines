;;05/25/16
;;What does it all mean, this Newell et al. stuff?
PRO JOURNAL__20160525__TEST_OUT_ALF_ESPEC_DB 

  LOAD_ALF_ESPEC_DB_AND_HASH,ae_stats,ae_hash

  LOAD_MAXIMUS_AND_CDBTIME,maximus,cdbTime,GOOD_I=good_i,HEMI__GOOD_I='NORTH'

  ;;Geniusery
  ;; maxVal                               = 0
  ;; FOREACH value,ae_hash,key DO maxVal  = ( N_ELEMENTS(value.x) GT maxVal) ? N_ELEMENTS(value.x) : maxVal

  ;;Get matching orbs
  uniq_eSpec_orbs   = ae_stats.orbit[UNIQ(ae_stats.orbit)]

  

  ;;The size of these gaps is unnerving
  diff              = (SHIFT(ae_stats.idx,-1))[0:-2]-ae_stats.idx[0:-2]
  
  CHECK_SORTED,good_i,gSorted,/QUIET
  CHECK_SORTED,ae_stats.idx,sSorted,/QUIET
  CHECK_UNIQUE,good_i,gUnique,/QUIET
  CHECK_UNIQUE,ae_stats.idx,sUnique,/QUIET
  IF gUnique AND sUnique AND gSorted AND sSorted THEN BEGIN
     MATCH,ae_stats.idx,good_i,ae_stats_ii
  ENDIF ELSE BEGIN
     PRINT,'One of either good_i or ae_stats.idx is not unique/sorted!'
     STOP
  ENDELSE

  i_with_espec      = CGSETINTERSECTION(ae_stats.idx,good_i,INDICES_A=ae_stats_ii, $
                                        INDICES_B=good_ii_with_eSpec, $
                                        COUNT=n_with_eSpec)
  IF i_with_espec[0] EQ -1 THEN STOP

  espec_uniq_orbs   = maximus.orbit[i_with_espec[UNIQ(maximus.orbit[i_with_espec])]]

  visited_orb_hash  = ORDEREDHASH(ae_hash.keys(),0)

  ;; maxVal         = 0
  ;; FOREACH value,ae_hash,key DO maxVal += N_ELEMENTS(value.x) 

  ae_innie          = !NULL
  ae_outie          = !NULL
  count             = 0
  maxChain          = 5
  nUniqOrbs         = N_ELEMENTS(espec_uniq_orbs)
  FOR k=0,nUniqOrbs-1 DO BEGIN

     curOrb         = espec_uniq_orbs[k]

     IF ( count LT (maxChain-1) ) THEN BEGIN
        CHAIN_ALF_ESPEC_STRUCTS,ae_innie,ae_hash[curOrb] ;loop here until we have maxChain-1 (for speed)
        count++
     ENDIF ELSE BEGIN
        CHAIN_ALF_ESPEC_STRUCTS,ae_innie,ae_hash[curOrb] ;get the last one

        CHAIN_ALF_ESPEC_STRUCTS,ae_outie,ae_innie
        ae_innie    = !NULL
        count       = 0
     ENDELSE

     IF ~visited_orb_hash[curOrb] THEN visited_orb_hash[curOrb]  = 1 ;update to make sure we don't come back

  ENDFOR

  IF N_ELEMENTS(ae_innie) NE 0 THEN BEGIN ;;The very last
     CHAIN_ALF_ESPEC_STRUCTS,ae_outie,ae_innie
     PRINT,'Picked up last ' + STRCOMPRESS(count,/REMOVE_ALL) + ' orbs from ae_innie...'
     ae_innie  = !NULL
     count     = 0
  ENDIF

  PRINT,FORMAT='("Total orbs visited: ",I0)',total((visited_orb_hash.values()).toarray())

  ;; STOP

  ;;;END FIRST ROUTINE--THE ONE THAT CATS THE ESPEC STRUCTS TOGETHER

  ;;START 2ND ROUTINE--THE ONE THAT JUST GRABS THE RELEVANT STUFF
  hits_for_this_ind = (ae_stats.hit_nSpectra[WHERE(ae_stats.nHits GT 0)])[ae_stats_ii]

  smokeMyMonster    = CGSETINTERSECTION(ae_outie.alf_indices,i_with_eSpec, $
                                        POSITIONS=catted_ii, $
                                        SUCCESS=success)
  IF smokeMyMonster[0] EQ -1 THEN STOP

  STOP

  ae_outie = { x:ae_outie.x[catted_ii], $
               MLT:ae_outie.mlt[catted_ii], $
               ILAT:ae_outie.ilat[catted_ii], $
               mono:ae_outie.mono[catted_ii], $
               broad:ae_outie.broad[catted_ii], $
               diffuse:ae_outie.diffuse[catted_ii], $
               Je:ae_outie.Je[catted_ii], $
               Jee:ae_outie.Jee[catted_ii], $
               nBad_eSpec:ae_outie.nBad_eSpec[catted_ii], $
               alf_indices:ae_outie.alf_indices[catted_ii]}

 plots = ALF_ESPEC_IDENTIFIED_PLOT(ae_outie)

  STOP

END
