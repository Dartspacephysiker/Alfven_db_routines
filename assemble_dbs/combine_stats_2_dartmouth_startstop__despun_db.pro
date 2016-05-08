;2016/01/08
;orbit 3620 is bogus for some reason
;so were a ton of them; I thought alfven_stats_5 would skip creating files with no Alfven waves, but it was making blanks...

PRO COMBINE_STATS_2_DARTMOUTH_STARTSTOP__DESPUN_DB,maximus
  
  ;; date          = '20160107'
  date          = '20160507'
  ;; Dartmouth_DB  = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5_14F/batch_output__ucla_mag_despin_201512/'
  Dartmouth_DB  = '/SPENCEdata/software/sdt/batch_jobs/Alfven_study/as5--add_later_orbs/batch_output__ucla_mag_despin_201512/'
  contents_file = './orbits_contained_in_DartDBfile_' + date + '--startstops_included.txt'

  ;;SEE BELOW FOR OUTFILE
  ;; outfile       = 'Dartdb_' + date + '--502-3619--maximus.sav'
  outDir        = '/SPENCEdata/Research/Cusp/database/dartdb/saves/'
  ;; outfile       = outDir + 'Dartdb_' + date + '--500-16361--maximus.sav'
  ;; outfile       = outDir + 'Dartdb_' + date + '--3621-10168--maximus.sav'
  ;; outfile       = outDir + 'Dartdb_' + date + '--10170-16361--maximus.sav'

  filePref      = 'Dartmouth_as5_dflux'
  fileSuff      = '----below_aur_oval--ucla_mag_despin'

;open file to write list of orbits included
  OPENW,outlun,contents_file,/get_lun

  min_orbit     = 10220
  max_orbit     = 16361

  outFile       = outDir + STRING(FORMAT='("Dartdb_",A0,"--",I0,"-",I0,"_despun--maximus.sav")', $
                                  date, $
                                  min_orbit, $
                                  max_orbit)

  ;;For Poynting flux
  mu_0 = DOUBLE(4.0D*!PI*1e-7)

  for j=min_orbit,max_orbit do begin

;    filename='Dartmouth_as5_startstop_dflux'+'_'+strcompress(j,/remove_all)+'_0'
     filename   = filePref+'_'+strcompress(j,/remove_all)+'_0' + fileSuff
                                ;filename='orb'+strcompress(j,/remove_all)+'_dflux'
     result=file_which(Dartmouth_DB,filename)
     if result then begin
        for jj=0,9 do begin
           result=file_which(Dartmouth_DB,filename)
           if result then begin
              print,j,jj
              printf,outlun,j,jj
              rdf_stats_dartmouth_as5_startstop_inc__despun,result,dat
              if j GT min_orbit then begin
                 maximus={ORBIT:[maximus.orbit,dat.orbit],$
                          ALFVENIC:[maximus.alfvenic,dat.alfvenic],$
                          TIME:[maximus.time,dat.time],$
                          ALT:[maximus.alt,dat.alt],$
                          MLT:[maximus.mlt,dat.mlt],$
                          ILAT:[maximus.ilat,dat.ilat],$
                          MAG_CURRENT:[maximus.MAG_CURRENT,dat.MAG_CURRENT],$
                          ESA_CURRENT:[maximus.ESA_CURRENT,dat.ESA_CURRENT],$
                          ELEC_ENERGY_FLUX:[maximus.ELEC_ENERGY_FLUX,dat.ELEC_ENERGY_FLUX],$
                          INTEG_ELEC_ENERGY_FLUX:[maximus.INTEG_ELEC_ENERGY_FLUX,dat.INTEG_ELEC_ENERGY_FLUX],$
                          EFLUX_LOSSCONE_INTEG:[maximus.EFLUX_LOSSCONE_INTEG,dat.EFLUX_LOSSCONE_INTEG],$
                          total_eflux_integ:[maximus.total_eflux_integ,dat.total_eflux_integ],$
                          max_chare_losscone:[maximus.max_chare_losscone,dat.max_chare_losscone],$
                          max_chare_total:[maximus.max_chare_total,dat.max_chare_total],$
                          ION_ENERGY_FLUX:[maximus.ION_ENERGY_FLUX,dat.ION_ENERGY_FLUX],$
                          ION_FLUX:[maximus.ION_FLUX,dat.ION_FLUX],$
                          ION_FLUX_UP:[maximus.ION_FLUX_UP,dat.ION_FLUX_UP],$
                          INTEG_ION_FLUX:[maximus.INTEG_ION_FLUX,dat.INTEG_ION_FLUX],$
                          INTEG_ION_FLUX_UP:[maximus.INTEG_ION_FLUX_UP,dat.INTEG_ION_FLUX_UP],$
                          CHAR_ION_ENERGY:[maximus.CHAR_ION_ENERGY,dat.CHAR_ION_ENERGY],$
                          WIDTH_TIME:[maximus.WIDTH_TIME,dat.WIDTH_TIME],$
                          WIDTH_X:[maximus.WIDTH_X,dat.WIDTH_X],$
                          DELTA_B:[maximus.DELTA_B,dat.DELTA_B],$
                          DELTA_E:[maximus.DELTA_E,dat.DELTA_E],$
                          SAMPLE_T:[maximus.SAMPLE_T,dat.SAMPLE_T],$
                          MODE:[maximus.MODE,dat.MODE],$
                          PROTON_FLUX_UP:[maximus.PROTON_FLUX_UP,dat.PROTON_FLUX_UP],$
                          PROTON_CHAR_ENERGY:[maximus.PROTON_CHAR_ENERGY,dat.PROTON_CHAR_ENERGY],$
                          OXY_FLUX_UP:[maximus.OXY_FLUX_UP,dat.OXY_FLUX_UP],$
                          OXY_CHAR_ENERGY:[maximus.OXY_CHAR_ENERGY,dat.OXY_CHAR_ENERGY],$
                          HELIUM_FLUX_UP:[maximus.HELIUM_FLUX_UP,dat.HELIUM_FLUX_UP],$
                          HELIUM_CHAR_ENERGY:[maximus.HELIUM_CHAR_ENERGY,dat.HELIUM_CHAR_ENERGY],$
                          SC_POT:[maximus.SC_POT,dat.SC_POT],$
                          L_PROBE:[maximus.L_PROBE,dat.L_PROBE],$
                          MAX_L_PROBE:[maximus.MAX_L_PROBE,dat.MAX_L_PROBE],$
                          MIN_L_PROBE:[maximus.MIN_L_PROBE,dat.MIN_L_PROBE],$
                          MEDIAN_L_PROBE:[maximus.MEDIAN_L_PROBE,dat.MEDIAN_L_PROBE],$
                          START_TIME:[maximus.START_TIME,dat.START_TIME],$
                          STOP_TIME:[maximus.STOP_TIME,dat.STOP_TIME],$
                          TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE,dat.TOTAL_ELECTRON_ENERGY_DFLUX_SINGLE],$
                          TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT:[maximus.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT,dat.TOTAL_ELECTRON_ENERGY_DFLUX_MULTIPLE_TOT],$
                          TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX:[maximus.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX,dat.TOTAL_ALFVEN_ELECTRON_ENERGY_DFLUX],$
                          TOTAL_ION_OUTFLOW_SINGLE:[maximus.TOTAL_ION_OUTFLOW_SINGLE,dat.TOTAL_ION_OUTFLOW_SINGLE],$
                          TOTAL_ION_OUTFLOW_MULTIPLE_TOT:[maximus.TOTAL_ION_OUTFLOW_MULTIPLE_TOT,dat.TOTAL_ION_OUTFLOW_MULTIPLE_TOT],$
                          TOTAL_ALFVEN_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_ION_OUTFLOW,dat.TOTAL_ALFVEN_ION_OUTFLOW],$
                          TOTAL_UPWARD_ION_OUTFLOW_SINGLE:[maximus.TOTAL_UPWARD_ION_OUTFLOW_SINGLE,dat.TOTAL_UPWARD_ION_OUTFLOW_SINGLE],$
                          TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT:[maximus.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT,dat.TOTAL_UPWARD_ION_OUTFLOW_MULTIPLE_TOT],$
                          TOTAL_ALFVEN_UPWARD_ION_OUTFLOW:[maximus.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW,dat.TOTAL_ALFVEN_UPWARD_ION_OUTFLOW]}
                 ;; pfluxest=DOUBLE((maximus.delta_e)*(maximus.delta_b*1e-9))/mu_0 ;;take away the factor of 1e-3 from E-field since we want mW/m^2                          ;; PFLUXEST:maximus.delta_b*maximus.delta_e*4.0e-7*!PI, $
                          ;; LSHELL:maximus.}
              endif else begin
                 maximus = dat
              endelse
           endif
           filename      = filePref + '_'+strcompress(j,/remove_all)+'_'+strcompress(jj+1,/remove_all)+fileSuff
        endfor
     endif
  endfor

  save,maximus,filename=outfile

  return

end
