FUNCTION GET_CHARE_INDS,dbStruct,minCharE,maxCharE, $
                        CHASTDB=chastDB, $
                        FOR_ESPEC_DB=for_eSpec_DB, $
                        FOR_ION_DB=for_ion_DB, $
                        LUN=lun

  COMPILE_OPT idl2

  dbType = 'char. energy'
  CASE 1 OF
     KEYWORD_SET(for_eSpec_DB): BEGIN
        chare = ABS(dbStruct.jee/dbStruct.je)*6.242*1.0e11
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

  chare_i = WHERE(chare GE minCharE AND chare LE maxCharE, $
                  NCOMPLEMENT=n_chare_outside_range)
  
  PRINTF,lun,FORMAT='("N lost to ",A0," restr. :",T35,I0)',dbType,n_chare_outside_range
  PRINTF,lun,''

  RETURN,chare_i

END