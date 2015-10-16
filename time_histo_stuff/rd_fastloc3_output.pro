;2015/04/07 The purpose of this pro is to read the files outputted by any of the fastloc* batch jobs
;and slap them into a 'dat' struct for us
PRO rd_fastloc3_output,filename,dat,outname
  fieldtypes=[3,7,4,4,4,4,4]
  fieldnames=['Orbit','Time','ALT','MLT','ILAT','FIELDS_MODE','SAMPLE_T']
  fieldlocations=[0,10,34,47,60,73,86]
  fieldgroups=[0,1,2,3,4,5,6]

  data_template={version:3.0,$
                 datastart:8,$
                 delimiter:' ',$
                 missingvalue:!Values.F_NAN,$
                 commentsymbol:';',$
                 fieldcount:[7],$
                 fieldtypes:fieldtypes,$
                 fieldnames:fieldnames,$
                 fieldlocations:fieldlocations,$
                 fieldgroups:fieldgroups}
  
 ;for testing
 ;restore,'rdf_as5_ascii_template.sav'
 ;dat=read_ascii(filename,template=tmplt)

  dat=read_ascii(filename,template=data_template)

 ;now read the integrated results
  openr,f_unit,filename,/get_lun
  junk=string(4444)
  t_start=string(4444)
  t_stop=string(4444)
  readf,f_unit,FORMAT='(A10,T13,A24,T40,A24)',junk,t_start,t_stop
  free_lun,f_unit
  ;; number=n_elements(dat.orbit)
  ;; TOTAL_ALFVEN_UPWARD_ION_OUTFLOW=make_array(number,value=TOTAL_ALFVEN_UPWARD_ION_OUTFLOW)
 
  ;interval stuff
  fNameLength = STRLEN(filename)
  interval = LONG(STRMID(filename,fNameLength-1,1))
  interval = MAKE_ARRAY(n_elements(dat.orbit),VALUE=interval)
  t_start =  MAKE_ARRAY(n_elements(dat.orbit),VALUE=t_start)
  t_stop =  MAKE_ARRAY(n_elements(dat.orbit),VALUE=t_stop)

  dat_orbit_integrated={$
                       INTERVAL:interval, $
                       INTERVAL_START:t_start, $
                       INTERVAL_STOP:t_stop, $
                       LSHELL:(cos(dat.ilat*!PI/180.))^(-2)}

  
  dat=create_struct(dat,dat_orbit_integrated)
  
  IF KEYWORD_SET(outname) THEN save, dat, filename=outname
  
  RETURN
END