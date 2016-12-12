;;12/11/16
PRO SAVE_PASIS_VARS, $
   FILENAME=fileName, $
   SAVEDIR=dir, $
   VERBOSE=verbose

  COMPILE_OPT IDL2

  @common__pasis_lists.pro

  saveDir = KEYWORD_SET(dir)      ? dir      : '/SPENCEdata/Research/Satellites/FAST/OMNI_FAST/temp/'
  fName   = KEYWORD_SET(fileName) ? fileName : GET_PASIS_VARS_FNAME()

  IF KEYWORD_SET(verbose) THEN BEGIN 
     IF FILE_TEST(saveDir+fName) THEN BEGIN
        thing = 'Overwriting'
     ENDIF ELSE BEGIN
        thing = 'Saving'
     ENDELSE

     PRINT,thing + " PASIS vars to " + saveDir + fName + ' ...'
  ENDIF

  SAVE,PASIS__paramString_list       , $
       PASIS__paramString            , $ 
       PASIS__plot_i_list            , $ 
       PASIS__fastLocInterped_i_list , $ 
       PASIS__indices__eSpec_list    , $ 
       PASIS__indices__ion_list      , $ 
       PASIS__eFlux_eSpec_data       , $    
       PASIS__eNumFlux_eSpec_data    , $ 
       PASIS__eSpec__MLTs            , $         
       PASIS__eSpec__ILATs           , $        
       PASIS__iFlux_eSpec_data       , $    
       PASIS__iNumFlux_eSpec_data    , $ 
       PASIS__ion_delta_t            , $ 
       PASIS__ion__MLTs              , $         
       PASIS__ion__ILATs             , $ 
       PASIS__alfDB_plot_struct      , $ 
       PASIS__IMF_struct             , $ 
       PASIS__MIMC_struct            , $
       FILENAME=saveDir+fName

END

