;2016/04/12 I seen this plot in Keiling et al. [2003], and I says to myself,
;"Hey! I could make one of those for my presentation!" So I'm all like, "How
; is it going to happen?" And then I get to writing some IDL code. Duh!
PRO JOURNAL__20160412__MAKE_KEILING_ET_AL_2003__PFLUX_GE_5ERGS_CM2_PLOT

  hemi                     = 'NORTH'
  ;; hemi                     = 'SOUTH'
  overlayAurZone           = 1

  ;; nonStorm                 = 1
  mainPhase                = 0

  centerLon                = 270
  sTrans                   = 96

  do_despun                = 0
  despunStr                = KEYWORD_SET(DO_despun) ? "--despun" : ''

  ;; altRange                 = [340,500]
  ;; altRange                 = [500,1000]
  ;; altRange                 = [1000,1500]
  ;; altRange                 = [1500,2000]
  ;; altRange                 = [2000,2500]
  ;; altRange                 = [2500,3000]
  ;; altRange                 = [3000,3500]
  ;; altRange                 = [3500,3750]
  ;; altRange                 = [3750,4000]
  ;; altRange                 = [4000,4175]
  ;; altRange                 = [340,500]
  ;; altRange                 = [500,1000]
  ;; altRange                 = [1000,1500]
  ;; altRange                 = [1500,2000]
  ;; altRange                 = [2000,2500]
  ;; altRange                 = [2500,3000]
  ;; altRange                 = [3000,3500]
  ;; altRange                 = [3500,3750]
  ;; altRange                 = [3750,4000]
  ;; altRange                 = [4000,4175]

  ;2016/04/13 For more direct comparison with Keiling et al. [2013]
  altRange                 = [4000,4175]
  sTrans                   = 90

  altStr                   = KEYWORD_SET(altRange) ? STRING(FORMAT='("--",I0,"-",I0,"km")',altRange[0],altRange[1]) : ''

  savePlot                 = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun
  good_i                   = GET_CHASTON_IND(maximus,HEMI=hemi,ALTITUDERANGE=altRange)

  IF KEYWORD_SET(nonStorm) OR KEYWORD_SET(mainPhase) OR KEYWORD_SET(recoveryPhase) THEN BEGIN
     GET_NONSTORM_MAINPHASE_AND_RECOVERYPHASE_FASTDB_INDICES, $
        DSTCUTOFF=dstCutoff, $
        NONSTORM_I=ns_i, $
        MAINPHASE_I=mp_i, $
        RECOVERYPHASE_I=rp_i, $
        STORM_DST_I=s_dst_i, $
        NONSTORM_DST_I=ns_dst_i, $
        MAINPHASE_DST_I=mp_dst_i, $
        RECOVERYPHASE_DST_I=rp_dst_i, $
        N_STORM=n_s, $
        N_NONSTORM=n_ns, $
        N_MAINPHASE=n_mp, $
        N_RECOVERYPHASE=n_rp, $
        NONSTORM_T1=ns_t1,MAINPHASE_T1=mp_t1,RECOVERYPHASE_T1=rp_t1, $
        NONSTORM_T2=ns_t2,MAINPHASE_T2=mp_t2,RECOVERYPHASE_T2=rp_t2

     lun=-1
     
     CASE 1 OF
        KEYWORD_SET(nonStorm): BEGIN
           PRINTF,lun,'Restricting with non-storm indices ...'
           restrict_with_these_i = ns_i
           t1_arr                = ns_t1
           t2_arr                = ns_t2
           stormString           = 'non-storm'
        END
        KEYWORD_SET(mainPhase): BEGIN
           PRINTF,lun,'Restricting with main-phase indices ...'
           restrict_with_these_i = mp_i
           t1_arr                = mp_t1
           t2_arr                = mp_t2
           stormString           = 'mainPhase'
        END
        KEYWORD_SET(recoveryPhase): BEGIN
           PRINTF,lun,'Restricting with recovery-phase indices ...'
           restrict_with_these_i = rp_i
           t1_arr                = rp_t1
           t2_arr                = rp_t2
           stormString           = 'recoveryPhase'
         END
     ENDCASE

     stormString                 = '--' + stormString
     good_i                      = CGSETINTERSECTION(good_i,restrict_with_these_i)
     gotStorms                   = 1
  ENDIF ELSE BEGIN
     stormString           = ''
  ENDELSE

  sPName                   = 'journal__20160412--keiling_et_al_2003_comparison--scatterplot' + despunStr + altStr + stormString +'--' + hemi + '.gif'
  plotTitle                = hemi + 'ERN HEMI: Poynting flux $\geq$ 5 mW/m!U2!N' + $
                             (KEYWORD_SET(altRange) OR KEYWORD_SET(gotStorms) ? '(' + altStr + stormString + ')' : '')

  pFlux_i                  = WHERE(ABS(maximus.pFluxEst) GE 5)
  
  good_i                   = CGSETINTERSECTION(good_i,pFlux_i)



  

  KEY_SCATTERPLOTS_POLARPROJ,MAXIMUS=maximus, $
                             HEMI=hemi, $
                             OVERLAYAURZONE=overlayAurZone, $
                             ADD_ORBIT_LEGEND=add_orbit_legend, $
                             CENTERLON=centerLon, $
                             OVERPLOT=overplot, $
                             LAYOUT=layout, $
                             PLOTPOSITION=plotPosition, $
                             OUT_PLOT=out_plot, $
                             CURRENT_WINDOW=window, $
                             PLOTSUFF=plotSuff, $
                             DBFILE=dbFile, $
                             JUST_PLOT_I=good_i, $
                             STRANS=sTrans, $
                             SAVEPLOT=savePlot, $
                             SPNAME=sPName, $
                             PLOTTITLE=plotTitle, $
                             _EXTRA = e


END
