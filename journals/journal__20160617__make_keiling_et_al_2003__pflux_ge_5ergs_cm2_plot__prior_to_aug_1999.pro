;2016/06/17 It does indeed seem that all IAW obs after Jul 1999 are bad.
PRO JOURNAL__20160617__MAKE_KEILING_ET_AL_2003__PFLUX_GE_5ERGS_CM2_PLOT__PRIOR_TO_AUG_1999

  pFluxMin                 = 5

  hemi                     = 'NORTH'
  ;; hemi                     = 'SOUTH'
  overlayAurZone           = 1

  ;; nonStorm                 = 1
  mainPhase                = 0

  centerLon                = 270
  ;; sTrans                   = 95
  sTrans                   = 95  ;for when you do all alts, you know

  do_despun                = 1
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
  ;; altRange                 = [4000,4175]
  altRange                 = [[4000,4180], $
                              [3680,4180], $
                              [3180,3680], $
                              [2680,3180], $
                              [2180,2680], $
                              [1680,2180], $
                              [1180,1680], $
                              [340,1180]]

  ;; altRange                 = [1500,4180]
  ;; altRange                 = [3640,4140]
  altRange                 = [0,4180]

  ;; altRange                 = [[3180,4180], $
  ;;                             [2180,3180], $
  ;;                             [1180,2180], $
  ;;                             [340,1180]]
                              
  orbRange                 = [500,11645]

  savePlot                 = 1

  LOAD_MAXIMUS_AND_CDBTIME,maximus,DO_DESPUNDB=do_despun
  good_i                   = GET_CHASTON_IND(maximus,HEMI=hemi)
  pFlux_i                  = WHERE(ABS(maximus.pFluxEst) GE pFluxMin)

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

  FOR i=0,N_ELEMENTS(altRange[0,*])-1 DO BEGIN

     altitudeRange            = altRange[*,i]

     alt_i                    = WHERE(maximus.alt GE altitudeRange[0] AND maximus.alt LE altitudeRange[1])
     orb_i                    = WHERE(maximus.orbit GE orbRange[0] AND maximus.orbit LT orbRange[1])
     these_i                  = CGSETINTERSECTION(CGSETINTERSECTION(alt_i,orb_i),pflux_i)
     IF these_i[0] EQ -1 THEN STOP
     these_i                  = CGSETINTERSECTION(these_i,good_i)
     
     altStr                   = KEYWORD_SET(altitudeRange) ? STRING(FORMAT='("--",I0,"-",I0,"km")',altitudeRange[0],altitudeRange[1]) : ''
     sPName                   = 'journal__20160617--keiling_et_al_2003_comparison--' + $
                                'before_Aug_1999--' + $
                                'pFlux_GE_' + STRING(FORMAT='(G0.2)',pFluxMin) + $
                                '--scatterplot' + despunStr + altStr + stormString + $
                                '--' + hemi + '.gif'
     plotTitle                = hemi + 'ERN HEMI: Poynting flux $\geq$ ' + STRCOMPRESS(pFluxMin,/REMOVE_ALL) + ' mW/m!U2!N' + $
                                (KEYWORD_SET(altitudeRange) OR KEYWORD_SET(gotStorms) ? '(' + altStr + stormString + ')' : '')
     

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
                                JUST_PLOT_I=these_i, $
                                STRANS=sTrans, $
                                SAVEPLOT=savePlot, $
                                SPNAME=sPName, $
                                /CLOSE_AFTER_SAVE, $
                                PLOTTITLE=plotTitle, $
                                _EXTRA = e

  ENDFOR



END
