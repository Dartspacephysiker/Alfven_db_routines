FUNCTION GET_CHARE_INDS,dbStruct,minCharE,maxCharE, $
                        NEWELL_THE_CUSP=Newell_the_cusp, $
                        BROADBAND_EVERYWHAR=broadband_everywhar, $
                        DIFFUSE_EVERYWHAR=diffuse_everywhar, $
                        CHASTDB=chastDB, $
                        FOR_ESPEC_DB=for_eSpec_DB, $
                        FOR_ION_DB=for_ion_DB, $
                        LUN=lun

  COMPILE_OPT idl2

  dbType = 'char. energy'
  CASE 1 OF
     KEYWORD_SET(for_eSpec_DB): BEGIN
        ;; chare = ABS(dbStruct.jee/dbStruct.je)*6.242*1.0e11
        chare = dbStruct.chare
     END
     KEYWORD_SET(for_ion_DB): BEGIN
        chare = ABS(dbStruct.jei/dbStruct.ji)*6.242*1.0e11
        dbType = 'char. ion energy'
     END
     KEYWORD_SET(chastDB): BEGIN
        chare = dbStruct.char_elec_energy
     END
     ELSE: BEGIN
        chare = dbStruct.max_chare_losscone
     END
  ENDCASE

  chare_i = WHERE((chare GE minCharE) AND (chare LE maxCharE), $
                  nCharE, $
                  NCOMPLEMENT=n_chare_outside_range)


  CASE 1 OF
     KEYWORD_SET(broadband_everywhar): BEGIN

        IF KEYWORD_SET(for_eSpec_DB) OR KEYWORD_SET(for_ion_DB) THEN BEGIN
           PRINT,"It's meaningless to broadband everywhar for the " + $
                 ( KEYWORD_SET(for_eSpec_DB) ? 'eSpec' : 'ion' ) + $
                 ' DB'
        ENDIF ELSE BEGIN
           broad_i  = WHERE(((dbStruct.mlt GT 9.5 ) AND $
                             (dbStruct.mlt LT 14.5) AND $
                             (charE        GE 300 )) OR $
                            ((dbStruct.mlt LE 9.5 ) OR $
                             (dbStruct.mlt GE 14.5) AND $
                             (charE        GE 80 )), $
                            nBroad)
           IF nBroad[0] EQ -1 THEN BEGIN
              PRINT,"Killed 'em all hunting for broadband!!"
           ENDIF
           chare_i = CGSETINTERSECTION( $
                     chare_i, $
                     broad_i, $
                     NORESULT=-1, $
                     COUNT=nCharE_broad)
           PRINTF,lun,FORMAT='("N lost to broadbanding everywhar",T35,": ",I0)', $
                  nCharE-nCharE_broad

        ENDELSE

     END
     KEYWORD_SET(diffuse_everywhar): BEGIN

        PRINT,'Diffusing everywhar ...'

        IF KEYWORD_SET(for_eSpec_DB) OR KEYWORD_SET(for_ion_DB) THEN BEGIN
           PRINT,"It's meaningless to diffuse everywhar for the " + $
                 ( KEYWORD_SET(for_eSpec_DB) ? 'eSpec' : 'ion' ) + $
                 ' DB'
        ENDIF ELSE BEGIN
           diff_i  = WHERE(((dbStruct.mlt GT 9.5 ) AND $
                            (dbStruct.mlt LT 14.5) AND $
                            (charE        LT 300 )) OR $
                           ((dbStruct.mlt LE 9.5 ) OR $
                            (dbStruct.mlt GE 14.5) AND $
                            (charE        LT 80 )), $
                           nDiff)
           IF nDiff[0] EQ -1 THEN BEGIN
              PRINT,"Killed 'em all hunting for diffuse!!"
           ENDIF
           chare_i = CGSETINTERSECTION( $
                     chare_i, $
                     diff_i, $
                     NORESULT=-1, $
                     COUNT=nCharE_diff)
           PRINTF,lun,FORMAT='("N lost to diffusing everywhar",T35,": ",I0)', $
                  nCharE-nCharE_diff

        ENDELSE

     END
     KEYWORD_SET(Newell_the_cusp): BEGIN
        ;;According to the Newell et al. [2009] strategy, kill obs. with characteristic energy < 300 eV if they lie between 9.5 and 14.5 MLT

        IF KEYWORD_SET(for_eSpec_DB) OR KEYWORD_SET(for_ion_DB) THEN BEGIN
           PRINT,"It's meaningless to Newell the cusp for the " + $
                 ( KEYWORD_SET(for_eSpec_DB) ? 'eSpec' : 'ion' ) + $
                 ' DB'
        ENDIF ELSE BEGIN
           chare_i = CGSETDIFFERENCE( $
                     chare_i, $
                     WHERE((dbStruct.mlt GT   9.5) AND $
                           (dbStruct.mlt LT  14.5) AND $
                           (chare        LT 300  )), $
                     NORESULT=-1, $
                     COUNT=nCharE_Newell)
           PRINTF,lun,FORMAT='("N lost to Newelling the cusp",T35,": ",I0)', $
                  nCharE-nCharE_Newell

        ENDELSE
     END
     ELSE: BEGIN
     END
  ENDCASE
  
  PRINTF,lun,FORMAT='("N lost to ",A0," restr. :",T35,I0)',dbType,n_chare_outside_range
  PRINTF,lun,''

  RETURN,chare_i

END