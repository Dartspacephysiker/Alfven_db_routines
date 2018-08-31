;2017/03/02
;Info on North-East-Down coordinates comes from §2.3.2.2 ECEF and Local NED Coordinate Systems in
;   G. Cai et al., Unmanned Rotorcraft Systems, Advances in Industrial Control,
;   DOI 10.1007/978-0-85729-635-1_2, © Springer-Verlag London Limited 2011
;
;Info on VDH coordinates comes from §3.3.9 VDH and §4.3.6 Vehicle-Dipole-Horizon (VDH) <- ECI* in
;   COORDINATE SYSTEMS FOR SPACE AND GEOPHYSICAL APPLICATIONS
;   K. H. Bhavnani and R. P. Vancour
;   December 11, 1991
;   Scientific Report No. 9
;   (http://www.dtic.mil/dtic/tr/fulltext/u2/a247550.pdf)
;
;2017/03/03
;Pay a visit to JOURNAL__20170302__INSPECT_COORDINATE_CONVERSIONS if you want to see how the results shake
FUNCTION DOTP,v1,v2
  RETURN,(TRANSPOSE(v1) # v2)[0]
END
FUNCTION VECNORM,vec
  RETURN,(SQRT(TRANSPOSE(vec) # vec))[0]
END
FUNCTION VNORMALIZE,vec
  ;; RETURN,[vec[0],vec[1],vec[2]]/SQRT(vec[0]*vec[0]+vec[1]*vec[1]+vec[2]*vec[2])
  RETURN,([vec[0],vec[1],vec[2]]/VECNORM(vec))
END
FUNCTION CROSSP_NORMED,v1,v2
  tmp = CROSSP(v1,v2)
  RETURN,VNORMALIZE(tmp)
END

PRO JOURNAL__20180828__CONVERT_OERSTED_ECEF_COORDS_TO_MAGNETIC

  COMPILE_OPT IDL2

  orig_routineName = 'JOURNAL__20180828__CONVERT_OERSTED_ECEF_COORDS_TO_MAGNETIC'
  R_E              = 6371.2D    ;Earth radius in km, from IGRFLIB_V2.pro

  outDir           = '/SPENCEdata/Research/database/Oersted/'

  ;; inFile           = 'oersted-ml990907.sav'
  ;; timeStrFile      = 'oersted-ml990907-timeStr.sav'
  ;; outFile          = 'oersted-ml990907-parsedCoordinates.sav'

  ;; Such money Alfveners for this conj with FAST
  date         = '991015'
  inFile       = 'oersted-ml' + date + '.sav'
  timeStrFile  = 'oersted-ml' + date + '-timeStr.sav'
  outFile      = 'oersted-ml' + date + '-parseCoordinates.sav'

  RESTORE,outDir+inFile

  ;; GEOPACK_CONV_COORD
  ;; Description: Convert between a variety of commonly used coordinate systems.
  ;; Calling Sequence: geopack_conv_coord(_08), s1, s2, s3, d1, d2, d3.
  ;; Inputs: s1, s2, s3: Coordinates in system of origin.
  ;; Outputs: d1, d2, d3: Coordinates in target system.
  ;; Keywords: FROM_GEO: Specify source in geopgraphic coordinates.
  ;;  FROM_MAG: Specify source in geomagnetic coordinates.
  ;;  FROM_GEI: Specify source in geocentric equatorial inertial coordinates.
  ;;  FROM_SM: Specify source in solar magnetic coordinates.
  ;;  FROM_GSM: Specify source in geocentric solar magnetospheric
  ;;  coordinates.
  ;;  FROM_GSE: Specify source in geocentric solar ecliptic coordinates.
  ;;  TO_GEO: Specify destination in geopgraphic coordinates.
  ;;  TO_MAG: Specify destination in geomagnetic coordinates.
  ;;  TO_GEI: Specify destination in geocentric equatorial inertial coordinates.
  ;;  TO_SM: Specify destination in solar magnetic coordinates.
  ;;  TO_GSM: Specify destination in geocentric solar magnetospheric
  ;;  coordinates.

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Times in CDF epoch time
  time_epoch    = UTC_TO_CDF_EPOCH(oersted.time)

  IF FILE_TEST(outDir+timeStrFile) THEN BEGIN
     PRINT,"Restoring timeString file " + outDir+timeStrFile + ' ...'
     RESTORE,outDir+timeStrFile
  ENDIF ELSE BEGIN
     PRINT,"Making " + STRCOMPRESS(N_ELEMENTS(oersted.time),/REMOVE_ALL) + " time strings ..."
     timeStr       = TIME_TO_STR(oersted.time,/MS)

     PRINT,"Saving timeStrs ..."
     SAVE,timeStr,FILENAME=outDir+timeStrFile
  ENDELSE

  ;; GEOPACK_RECALC_08
  ;; GEOPACK_CONV_COORD_08,cuspLoc_MAG[0],cuspLoc_MAG[1],cuspLoc_MAG[2],clgeo_x,clgeo_y,clgeo_z,/FROM_MAG,/TO_GEO,EPOCH=time_epoch

  YearArr       = FIX(STRMID(timeStr,0,4))
  MonthArr      = FIX(STRMID(timeStr,5,2))
  DayArr        = FIX(STRMID(timeStr,8,2))
  HourArr       = FIX(STRMID(timeStr,11,2))
  MinArr        = FIX(STRMID(timeStr,14,2))
  SecArr        = FLOAT(STRMID(timeStr,17,6))

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;feed it to GEOPACK
  nTot             = N_ELEMENTS(oersted.time)

  TiltArr          = !NULL

  pos_GEO_arr      = MAKE_ARRAY(3,nTot,/FLOAT)
  pos_GEI_arr      = MAKE_ARRAY(3,nTot,/FLOAT)
  pos_GSM_arr      = MAKE_ARRAY(3,nTot,/FLOAT)
  pos_GEISph_arr   = MAKE_ARRAY(3,nTot,/FLOAT)
  pos_GEOSph_arr   = MAKE_ARRAY(3,nTot,/FLOAT)
  pos_GSMSph_arr   = MAKE_ARRAY(3,nTot,/DOUBLE)
  pos_MAG_arr      = MAKE_ARRAY(3,nTot,/FLOAT)
  pos_MAGSph_arr   = MAKE_ARRAY(3,nTot,/DOUBLE)
  pos_NED_arr      = MAKE_ARRAY(3,nTot,/DOUBLE)
  alt_GEO          = MAKE_ARRAY(nTot,/DOUBLE)
  lat_GEO          = MAKE_ARRAY(nTot,/DOUBLE)

  vel_FAC_arr      = MAKE_ARRAY(3,nTot,/DOUBLE)
  vel_FACV_arr     = MAKE_ARRAY(3,nTot,/DOUBLE)
  vel_GEI_arr      = MAKE_ARRAY(3,nTot,/DOUBLE)
  vel_GEO_arr      = MAKE_ARRAY(3,nTot,/DOUBLE)
  vel_GEOSph_arr   = MAKE_ARRAY(3,nTot,/DOUBLE)
  vel_MAG_arr      = MAKE_ARRAY(3,nTot,/DOUBLE)
  vel_MAGSph_arr   = MAKE_ARRAY(3,nTot,/DOUBLE)
  vel_NED_arr      = MAKE_ARRAY(3,nTot,/DOUBLE)
  vel_VDH_arr      = MAKE_ARRAY(3,nTot,/DOUBLE)

  B_FAC_arr        = MAKE_ARRAY(3,nTot,/DOUBLE)
  B_FACV_arr       = MAKE_ARRAY(3,nTot,/DOUBLE)
  B_GEI_arr        = MAKE_ARRAY(3,nTot,/DOUBLE)
  B_GEOSph_arr     = MAKE_ARRAY(3,nTot,/DOUBLE)
  B_MAG_arr        = MAKE_ARRAY(3,nTot,/DOUBLE)
  B_MAGSph_arr     = MAKE_ARRAY(3,nTot,/DOUBLE)
  B_NED_arr        = MAKE_ARRAY(3,nTot,/DOUBLE)
  B_VDH_arr        = MAKE_ARRAY(3,nTot,/DOUBLE)
 
  IGRF_FAC_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  IGRF_GEI_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  IGRF_GEO_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  IGRF_GEO_sphArr  = MAKE_ARRAY(3,nTot,/FLOAT)
  IGRF_GSM_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  IGRF_GSM_sphArr  = MAKE_ARRAY(3,nTot,/FLOAT)
  IGRF_GSM_DIP_arr = MAKE_ARRAY(3,nTot,/FLOAT)
  IGRF_VDH_arr     = MAKE_ARRAY(3,nTot,/FLOAT)

  B_FAC_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  B_GEI_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  B_GEO_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  B_GEO_sphArr  = MAKE_ARRAY(3,nTot,/FLOAT)
  B_GSM_arr     = MAKE_ARRAY(3,nTot,/FLOAT)
  B_GSM_sphArr  = MAKE_ARRAY(3,nTot,/FLOAT)
  B_VDH_arr     = MAKE_ARRAY(3,nTot,/FLOAT)

  ;;for vector transforms
  ident            = IDENTITY(3,/DOUBLE)

  GEO2FAC_vec      = MAKE_ARRAY(3,3,nTot,/DOUBLE)
  GEO2FACV_vec     = MAKE_ARRAY(3,3,nTot,/DOUBLE)

  ;; GEI
  GEO2GEI_vec      = MAKE_ARRAY(3,3,nTot,/DOUBLE)
  GEO2GEI_fakeVec  = MAKE_ARRAY(3,3,nTot,/DOUBLE)

  ;; MAG
  GEO2MAG_vec      = MAKE_ARRAY(3,3,nTot,/DOUBLE)
  GEO2MAG_fakeVec  = MAKE_ARRAY(3,3,nTot,/DOUBLE)

  ;; GSM
  GEO2GSM_vec      = MAKE_ARRAY(3,3,nTot,/DOUBLE)
  GEO2GSM_fakeVec  = MAKE_ARRAY(3,3,nTot,/DOUBLE)

  ;;North-East-Down
  GEO2NED_vec      = MAKE_ARRAY(3,3,nTot,/DOUBLE)
  GEO2NED_fakeVec  = MAKE_ARRAY(3,3,nTot,/DOUBLE)

  GEI2VDH_vec      = MAKE_ARRAY(3,3,nTot,/DOUBLE)

  ;; Get initial velocity
  ;; Put angular components in RADIANS for GEOPACK routines, som krevde
  pos_r_GEO0       = DOUBLE(oersted.ecef.r[0]    )*1000.D
  pos_theta_GEO0   = DOUBLE(oersted.ecef.theta[0]);*!DTOR
  pos_phi_GEO0     = DOUBLE(oersted.ecef.phi[0]  );*!DTOR
  pos_r_GEO1       = DOUBLE(oersted.ecef.r[1]    )*1000.D
  pos_theta_GEO1   = DOUBLE(oersted.ecef.theta[1]);*!DTOR
  pos_phi_GEO1     = DOUBLE(oersted.ecef.phi[1]  );*!DTOR

  dt0              = oersted.time[1]-oersted.time[0]

  tmpPos_GEO_sph0  = DOUBLE([pos_r_GEO0,pos_theta_GEO0,pos_phi_GEO0])
  tmpPos_GEO_sph1  = DOUBLE([pos_r_GEO1,pos_theta_GEO1,pos_phi_GEO1])
  GEOPACK_SPHCAR_08,tmpPos_GEO_sph0[0],tmpPos_GEO_sph0[1],tmpPos_GEO_sph0[2], $
                    pos_x_GEO0,pos_y_GEO0,pos_z_GEO0,/TO_RECT,/DEGREE
  GEOPACK_SPHCAR_08,tmpPos_GEO_sph1[0],tmpPos_GEO_sph1[1],tmpPos_GEO_sph1[2], $
                    pos_x_GEO1,pos_y_GEO1,pos_z_GEO1,/TO_RECT,/DEGREE

  tmpVel_GEO0      = [pos_x_GEO1-pos_x_GEO0,pos_y_GEO1-pos_y_GEO0,pos_z_GEO1-pos_z_GEO0]/dt0

  FOR i=0,nTot-1 DO BEGIN
     GEOPACK_RECALC_08,YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i],/DATE

     ;;Convert everything to meters.
     ;; Here's why (execute these lines down to PRINT,renu2.ecef[...]):
     ;; outDir_RENU           = '/SPENCEdata/Research/database/RENU2/'
     ;; inFile_RENU           = 'RENU2_GPS.sav'
     ;; timeStrFile_RENU      = 'RENU2_GPS--timeStr.sav'
     ;; outFile_RENU          = 'RENU2_coordinates.sav'
     ;; RESTORE,outdir_renu+infile_renu
     ;; PRINT,renu2.ecef.position.x[0],renu2.ecef.position.y[0],renu2.ecef.position.z[0]

     ;; Put angular components in RADIANS for GEOPACK routines, som krevde
     pos_r_GEO       = DOUBLE(oersted.ecef.r[i]    )*1000.D
     pos_theta_GEO   = DOUBLE(oersted.ecef.theta[i]);*!DTOR
     pos_phi_GEO     = (DOUBLE(oersted.ecef.phi[i]  ) + 360.D) MOD 360.D;*!DTOR

     tmpPos_GEO_sph  = DOUBLE([pos_r_GEO,pos_theta_GEO,pos_phi_GEO])


     GEOPACK_SPHCAR_08,tmpPos_GEO_sph[0],tmpPos_GEO_sph[1],tmpPos_GEO_sph[2], $
                       pos_x_GEO,pos_y_GEO,pos_z_GEO,/TO_RECT,/DEGREE


     tmpPos_GEO = [pos_x_GEO,pos_y_GEO,pos_z_GEO]

     ;; Need to calculate velocity
     IF i EQ 0 THEN BEGIN
        tmpVel_GEO = tmpVel_GEO0
     ENDIF ELSE BEGIN
        tmpVel_GEO = [pos_x_GEO-lastPos_x_GEO,pos_y_GEO-lastPos_y_GEO,pos_z_GEO-lastPos_z_GEO]/(oersted.time[i]-oersted.time[i-1])
     ENDELSE


     ;;To GEI
     GEOPACK_CONV_COORD_08,tmpPos_GEO[0],tmpPos_GEO[1],tmpPos_GEO[2], $
                           pos_x_GEI,pos_y_GEI,pos_z_GEI, $
                           /FROM_GEO,/TO_GEI,EPOCH=time_epoch[i]
     ;;To MAG
     GEOPACK_CONV_COORD_08,tmpPos_GEO[0],tmpPos_GEO[1],tmpPos_GEO[2], $
                           pos_x_MAG,pos_y_MAG,pos_z_MAG, $
                           /FROM_GEO,/TO_MAG,EPOCH=time_epoch[i]

     ;;To GSM for IGRF calc
     GEOPACK_CONV_COORD_08,tmpPos_GEO[0],tmpPos_GEO[1],tmpPos_GEO[2], $
                           pos_x_GSM,pos_y_GSM,pos_z_GSM, $
                           /FROM_GEO,/TO_GSW,EPOCH=time_epoch[i]


     ;;And spherical everything
     GEOPACK_SPHCAR_08,pos_x_GEI,pos_y_GEI,pos_z_GEI, $
                       pos_r_GEI,pos_theta_GEI,pos_phi_GEI,/TO_SPHERE,/DEGREE
     GEOPACK_SPHCAR_08,tmpPos_GEO[0],tmpPos_GEO[1],tmpPos_GEO[2], $
                       pos_r_GEO2,pos_theta_GEO2,pos_phi_GEO2,/TO_SPHERE,/DEGREE
     diffR = (pos_r_GEO2-pos_r_GEO)/pos_r_GEO
     diffTheta = (pos_theta_GEO2-pos_theta_GEO)/pos_theta_GEO
     diffPhi = (pos_phi_GEO2-pos_phi_GEO)/pos_phi_GEO

     ;; A check on the conversion
     IF ABS(diffR) GT 0.001 OR ABS(diffTheta) GT 0.001 OR ABS(diffPhi) GT 0.001 THEN STOP

     GEOPACK_SPHCAR_08,pos_x_GSM,pos_y_GSM,pos_z_GSM, $
                       pos_r_GSM,pos_theta_GSM,pos_phi_GSM,/TO_SPHERE,/DEGREE
     GEOPACK_SPHCAR_08,pos_x_MAG,pos_y_MAG,pos_z_MAG, $
                       pos_r_MAG,pos_theta_MAG,pos_phi_MAG,/TO_SPHERE,/DEGREE

     ;;Velocity vector in spherical GEO coords
     GEOPACK_BCARSP_08,tmpPos_GEO[0],tmpPos_GEO[1],tmpPos_GEO[2], $
                       tmpVel_GEO[0],tmpVel_GEO[1],tmpVel_GEO[2], $
                       vel_GEO_r,vel_GEO_theta,vel_GEO_phi

     b_r_GEO     = oersted.b.r[i]
     b_theta_GEO = oersted.b.theta[i]
     b_phi_GEO   = oersted.b.phi[i]

     ;;Get IGRF
     pos_gsm_xyz_R_E  = [pos_x_GSM,pos_y_GSM,pos_z_GSM]/1000.D/R_E ;div by 1000 to get to km, then by R_E (which is in units of km)
     ;; GEOPACK_RECALC_08,YearArr[i],MonthArr[i],DayArr[i],HourArr[i],MinArr[i],SecArr[i],/DATE
     GEOPACK_IGRF_GEO_08,pos_r_GEO/1000./R_E,pos_theta_GEO,pos_phi_GEO, $
                         bIGRF_r_GEO,bIGRF_theta_GEO,bIGRF_phi_GEO, $
                         EPOCH=time_epoch[i],/DEGREE
     ;; IGRF
     GEOPACK_BSPCAR_08  ,pos_theta_GEO,pos_phi_GEO, $
                         bIGRF_r_GEO,bIGRF_theta_GEO,bIGRF_phi_GEO, $
                         bIGRF_x_GEO,bIGRF_y_GEO,bIGRF_z_GEO,/DEGREE ; ,EPOCH=time_epoch[i]
     ;; Measured
     GEOPACK_BSPCAR_08  ,pos_theta_GEO,pos_phi_GEO, $
                         b_r_GEO,b_theta_GEO,b_phi_GEO, $
                         b_x_GEO,b_y_GEO,b_z_GEO,/DEGREE ; ,EPOCH=time_epoch[i]


     ;;alternate shot at IGRF
     GEOPACK_IGRF_GSW_08,pos_gsm_xyz_R_E[0],pos_gsm_xyz_R_E[1],pos_gsm_xyz_R_E[2], $
                         bIGRF_x_GSM,bIGRF_y_GSM,bIGRF_z_GSM, $
                         EPOCH=time_epoch[i]
     GEOPACK_BCARSP_08  ,pos_gsm_xyz_R_E[0],pos_gsm_xyz_R_E[1],pos_gsm_xyz_R_E[2], $
                         bIGRF_x_GSM,bIGRF_y_GSM,bIGRF_z_GSM, $
                         bIGRF_r_GSM,bIGRF_theta_GSM,bIGRF_phi_GSM


     ;; NEED THESE EARLY
     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;GEO to GSM
     GEOPACK_CONV_COORD_08,ident[0,0],ident[0,1],ident[0,2], $
                           gsm_x0,gsm_y0,gsm_z0, $
                           /FROM_GEO,/TO_GSW,EPOCH=time_epoch[i]

     GEOPACK_CONV_COORD_08,ident[1,0],ident[1,1],ident[1,2], $
                           gsm_x1,gsm_y1,gsm_z1, $
                           /FROM_GEO,/TO_GSW,EPOCH=time_epoch[i]

     GEOPACK_CONV_COORD_08,ident[2,0],ident[2,1],ident[2,2], $
                           gsm_x2,gsm_y2,gsm_z2, $
                           /FROM_GEO,/TO_GSW,EPOCH=time_epoch[i]

     GEO2GSM_vec[*,*,i] = [[gsm_x0,gsm_y0,gsm_z0], $
                                [gsm_x1,gsm_y1,gsm_z1], $
                                [gsm_x2,gsm_y2,gsm_z2]]
     ;; GEO2GSM_fakeVec[*,*,i]   = INVERT(GEO2GSM_vec[*,*,i])

     B_GSM_arr[*,i]       = GEO2GSM_vec[*,*,i]    # [b_x_GEO,b_y_GEO,b_z_GEO]
     b_x_GSM              = B_GSM_arr[0,i]
     b_y_GSM              = B_GSM_arr[1,i]
     b_z_GSM              = B_GSM_arr[2,i]
     ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


     ;; Alternate shot at measured B
     GEOPACK_BCARSP_08  ,pos_gsm_xyz_R_E[0],pos_gsm_xyz_R_E[1],pos_gsm_xyz_R_E[2], $
                         b_x_GSM,b_y_GSM,b_z_GSM, $
                         b_r_GSM,b_theta_GSM,b_phi_GSM

     ;;Dipole, please?
     GEOPACK_DIP_08,pos_gsm_xyz_R_E[1],pos_gsm_xyz_R_E[1],pos_gsm_xyz_R_E[2], $
                    bIGRF_x_GSM_dip,bIGRF_y_GSM_dip,bIGRF_z_GSM_dip, $
                    EPOCH=time_epoch[i] ;,/DEGREE

     ;;Update not-spherical
     ;; TiltArr              = [TiltArr,tempTilt]
     pos_GEO_arr[*,i]        = [pos_x_GEO,pos_y_GEO,pos_z_GEO]
     pos_GEI_arr[*,i]        = [pos_x_GEI,pos_y_GEI,pos_z_GEI]
     pos_GSM_arr[*,i]        = [pos_x_GSM,pos_y_GSM,pos_z_GSM]
     pos_MAG_arr[*,i]        = [pos_x_MAG,pos_y_MAG,pos_z_MAG]

     ;;Update spherical
     pos_GEISph_arr[*,i]     = [pos_theta_GEI,pos_phi_GEI,pos_r_GEI]
     pos_GEOSph_arr[*,i]     = [pos_theta_GEO,pos_phi_GEO,pos_r_GEO] ;Redundant, yes, but a check
     pos_GSMSph_arr[*,i]     = [pos_theta_GSM,pos_phi_GSM,pos_r_GSM]
     pos_MAGSph_arr[*,i]     = [pos_theta_MAG,pos_phi_MAG,pos_r_MAG]

     vel_GEO_arr[*,i]        = [tmpVel_GEO[0],tmpVel_GEO[1],tmpVel_GEO[2]]
     vel_GEOSph_arr[*,i]     = [vel_GEO_r,vel_GEO_theta,vel_GEO_phi]

     ;; IGRF
     IGRF_GEO_sphArr[*,i]    = [bIGRF_theta_GEO,bIGRF_phi_GEO,bIGRF_r_GEO]
     IGRF_GSM_sphArr[*,i]    = [bIGRF_theta_GSM,bIGRF_phi_GSM,bIGRF_r_GSM]
     ;;Update IGRFs
     IGRF_GSM_DIP_arr[*,i]   = [bIGRF_x_GSM_dip,bIGRF_y_GSM_dip,bIGRF_z_GSM_dip]
     IGRF_GEO_arr[*,i]       = [bIGRF_x_GEO,bIGRF_y_GEO,bIGRF_z_GEO]
     IGRF_GSM_arr[*,i]       = [bIGRF_x_GSM,bIGRF_y_GSM,bIGRF_z_GSM]

     ;; Meas
     B_GEO_sphArr[*,i]    = [b_theta_GEO,b_phi_GEO,b_r_GEO]
     B_GSM_sphArr[*,i]    = [b_theta_GSM,b_phi_GSM,b_r_GSM]
     ;;Update Meas
     B_GEO_arr[*,i]       = [b_x_GEO,b_y_GEO,b_z_GEO]
     B_GSM_arr[*,i]       = [b_x_GSM,b_y_GSM,b_z_GSM]

     ;;Where is magnetic center of earth?
     GEOPACK_CONV_COORD_08,0D,0D,0D, $
                           pos_magCenter_x_GEI,pos_magCenter_y_GEI,pos_magCenter_z_GEI, $
                           /FROM_MAG,/TO_GEI,EPOCH=time_epoch[i]
     pos_magCenter_GEI       = [TEMPORARY(pos_magCenter_x_GEI),TEMPORARY(pos_magCenter_y_GEI),TEMPORARY(pos_magCenter_z_GEI)]

     ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Now transform matrices

     ;;GEO to GEI
     GEOPACK_CONV_COORD_08,ident[0,0],ident[0,1],ident[0,2], $
                           gei_x0,gei_y0,gei_z0, $
                           /FROM_GEO,/TO_GEI,EPOCH=time_epoch[i]

     GEOPACK_CONV_COORD_08,ident[1,0],ident[1,1],ident[1,2], $
                           gei_x1,gei_y1,gei_z1, $
                           /FROM_GEO,/TO_GEI,EPOCH=time_epoch[i]

     GEOPACK_CONV_COORD_08,ident[2,0],ident[2,1],ident[2,2], $
                           gei_x2,gei_y2,gei_z2, $
                           /FROM_GEO,/TO_GEI,EPOCH=time_epoch[i]

     ;;GEO to MAG
     GEOPACK_CONV_COORD_08,ident[0,0],ident[0,1],ident[0,2], $
                           mag_x0,mag_y0,mag_z0, $
                           /FROM_GEO,/TO_MAG,EPOCH=time_epoch[i]

     GEOPACK_CONV_COORD_08,ident[1,0],ident[1,1],ident[1,2], $
                           mag_x1,mag_y1,mag_z1, $
                           /FROM_GEO,/TO_MAG,EPOCH=time_epoch[i]

     GEOPACK_CONV_COORD_08,ident[2,0],ident[2,1],ident[2,2], $
                           mag_x2,mag_y2,mag_z2, $
                           /FROM_GEO,/TO_MAG,EPOCH=time_epoch[i]

     ;;GEO to NED (North-East-Down)
     ;; xmu: "Geodetic latitude" (fra GEOPACK 2008 dokumentasjon)
     GEOPACK_GEODGEO_08,pos_r_GEO/1000.,pos_theta_GEO,h,xmu,/TO_GEODETIC,/DEGREE

     alt_GEO[i]             = h
     lat_GEO[i]             = xmu

     ;; Ørsted altitude ranges from 650–875 km, so h GT 1000 is a clear varselskilt
     IF h GT 1000 THEN STOP
     
     ;;**Get colatitude (refTheta) and altitude in GEO coordinates from geodetic
     ;; reference altitude (sea level, or 0.D) and geodetic latitude (xmu)
     GEOPACK_GEODGEO_08,0.D,xmu, $
                        refAlt_GEO,refTheta_GEO,/TO_GEOCENTRIC,/DEGREE ;/TO_GEODETIC (see GEOPACK_2008 documentation, or type GEOPACK_HELP)
     GEOPACK_SPHCAR_08,refAlt_GEO,refTheta_GEO,pos_phi_GEO, $
                       refAlt_x,refAlt_y,refAlt_z,/TO_RECT,/DEGREE

     tmpGEODRef              = [refAlt_x,refAlt_y,refAlt_z]
     tmpNEDRefPos_GEO        = [tmpPos_GEO[0]-tmpGEODRef[0],tmpPos_GEO[1]-tmpGEODRef[1],tmpPos_GEO[2]-tmpGEODRef[2]]

     ;;GEI to VDH (Vertical [vehicle?]-Down-Horizontal)

     ;;**First, Get vector pointing east in GEO coordinates
     ;;  Later we'll transform to GEI coordinates with GEO2GEI_arr
     GEOPACK_BSPCAR_08,refTheta_GEO,pos_phi_GEO, $
                       0.D,0.D,1.D, $
                       eEast_x_GEO,eEast_y_GEO,eEast_z_GEO,/DEGREE
     eEast_Car_GEO           = [TEMPORARY(eEast_x_GEO),TEMPORARY(eEast_y_GEO),TEMPORARY(eEast_z_GEO)]

     ;;**Also, vector along magnetic pole (northward) in GEI coordinates, which is H_hat (if normalized) in VDH system
     GEOPACK_CONV_COORD_08,0.D,0.D,1.D, $
                           magPole_x0_GEI,magPole_y0_GEI,magPole_z0_GEI, $
                           /FROM_MAG,/TO_GEI,EPOCH=time_epoch[i]
     magPole_GEI             = [TEMPORARY(magPole_x0_GEI),TEMPORARY(magPole_y0_GEI),TEMPORARY(magPole_z0_GEI)]

     ;;**Here are some other ingredients for VDH transform
     hHat_GEI                = magPole_GEI
     ;; rPos_norm_GEI           = SQRT(pos_x_GEI*pos_x_GEI+pos_y_GEI*pos_y_GEI+pos_z_GEI*pos_z_GEI)
     ;; rPosHat_GEI             = [pos_x_GEI,pos_y_GEI,pos_z_GEI]/rPos_norm_GEI
     rPosHat_Car_GEI         = VNORMALIZE([pos_x_GEI,pos_y_GEI,pos_z_GEI])
     dHat_GEI                = CROSSP_NORMED(hHat_GEI,rPosHat_Car_GEI)
     vHat_GEI                = CROSSP_NORMED(dHat_GEI,hHat_GEI)

           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Field-aligned coordinate systems

     ;;FAC system 1 (ripped from UCLA_MAG_DESPIN)
     ;;   "Field-aligned coordinates defined as:   "
     ;;   "z-along B, y-east (BxR), x-nominally out"

     bHat_GEO                = VNORMALIZE([bIGRF_x_GEO,bIGRF_y_GEO,bIGRF_z_GEO])        ;along-b unit vector (or zHat)
     rPosHat_Car_GEO         = VNORMALIZE(tmpPos_GEO)
     eHat_GEO                = CROSSP_NORMED(bHat_GEO,rPosHat_Car_GEO)       ;eastward unit vector (or yHat)
     oHat_GEO                = CROSSP_NORMED(eHat_GEO,bHat_GEO)              ;"nominally out" unit vector (or xHat)

     ;;FAC system 2 (ripped from UCLA_MAG_DESPIN)
     ;;   "Field-aligned velocity-based coordinates defined as: "
     ;;   "z-along B, y-cross track (BxV), x-along track ((BxV)xB)."

     vHat_GEO                = VNORMALIZE(tmpVel_GEO)
     cHat_GEO                = CROSSP_NORMED(bHat_GEO,vHat_GEO)       ;cross-track unit vector (or yHat)
     aHat_GEO                = CROSSP_NORMED(cHat_GEO,bHat_GEO)       ;along-track unit vector (or xHat)

           ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
     ;;Update arrays of transformation matrices
     GEO2GEI_vec[*,*,i]    = [[gei_x0,gei_y0,gei_z0], $
                                [gei_x1,gei_y1,gei_z1], $
                                [gei_x2,gei_y2,gei_z2]]
     GEO2MAG_vec[*,*,i]    = [[mag_x0,mag_y0,mag_z0], $
                                [mag_x1,mag_y1,mag_z1], $
                                [mag_x2,mag_y2,mag_z2]]

     tmpLambda              = pos_phi_GEO*!DTOR
     tmpPhi                 = xmu*!DTOR
     GEO2NED_vec[*,*,i]    = [[-SIN(tmpPhi)*COS(tmpLambda),-SIN(tmpPhi)*SIN(tmpLambda),COS(tmpPhi)], $
                                [-SIN(tmpLambda)            ,COS(tmpLambda)             ,0.D         ], $
                                [-COS(tmpPhi)*COS(tmpLambda),-COS(tmpPhi)*SIN(tmpLambda),-SIN(tmpPhi)]]

     GEO2FACV_vec[*,*,i]     = INVERT([[aHat_GEO],[cHat_GEO],[bHat_GEO]],/DOUBLE)
     GEO2FAC_vec[*,*,i]      = INVERT([[oHat_GEO],[eHat_GEO],[bHat_GEO]],/DOUBLE)
     ;; GEO2GEI_fakeVec[*,*,i]      = INVERT(GEO2GEI_vec[*,*,i])
     ;; GEO2MAG_fakeVec[*,*,i]      = INVERT(GEO2MAG_vec[*,*,i])
     ;; GEO2NED_fakeVec[*,*,i]      = INVERT(GEO2NED_vec[*,*,i])

     ;;get velocity and magnetic field (as a check) in FAC and FACV coordinates
     vel_FAC_arr[*,i]        = GEO2FAC_vec[*,*,i]    # tmpVel_GEO
     vel_FACV_arr[*,i]       = GEO2FACV_vec[*,*,i]   # tmpVel_GEO

     IGRF_FAC_arr[*,i]       = GEO2FAC_vec[*,*,i]    # [bIGRF_x_GEO,bIGRF_y_GEO,bIGRF_z_GEO]
     B_FAC_arr[*,i]          = GEO2FAC_vec[*,*,i]    # [b_x_GEO,b_y_GEO,b_z_GEO]

     ;;get velocity and magnetic field in GEI coordinates
     vel_GEI_arr[*,i]        = GEO2GEI_vec[*,*,i]    # tmpVel_GEO
     IGRF_GEI_arr[*,i]       = GEO2GEI_vec[*,*,i]    # [bIGRF_x_GEO,bIGRF_y_GEO,bIGRF_z_GEO]
     B_GEI_arr[*,i]          = GEO2GEI_vec[*,*,i]    # [b_x_GEO,b_y_GEO,b_z_GEO]

     ;;get velocity in MAG coordinates (Cartesian and spherical)
     vel_MAG_arr[*,i]        = GEO2MAG_vec[*,*,i]    # tmpVel_GEO
     GEOPACK_BCARSP_08,pos_x_MAG,pos_y_MAG,pos_z_MAG, $
                       vel_MAG_arr[0,i],vel_MAG_arr[1,i],vel_MAG_arr[2,i], $
                       magVSph_r,magVSph_theta,magVSph_phi
     vel_MAGSph_arr[*,i]     = [magVSph_r,magVSph_theta,magVSph_phi]


     pos_NED_arr[*,i]        = GEO2NED_vec[*,*,i]  # TEMPORARY(tmpNEDRefPos_GEO)
     vel_NED_arr[*,i]        = GEO2NED_vec[*,*,i]    # tmpVel_GEO

     ;;get velocity and magnetic field in VDH

     eEast_Car_GEI           = GEO2GEI_vec[*,*,i]    # eEast_Car_GEO
     ;; IF (TRANSPOSE(dHat_GEI) # eEast_Car_GEI) LT 0 THEN BEGIN
     IF DOTP(dHat_GEI,eEast_Car_GEI) LT 0 THEN BEGIN
        dHat_GEI            *= (-1D)
        vHat_GEI            *= (-1D)
     ENDIF

     GEI2VDH_vec[*,*,i]      = [[vHat_GEI],[dHat_GEI],[hHat_GEI]]

     vel_VDH_arr[*,i]        = GEI2VDH_vec[*,*,i]    # vel_GEI_arr[*,i]
     IGRF_VDH_arr[*,i]       = GEI2VDH_vec[*,*,i]    # IGRF_GEI_arr[*,i]
     B_VDH_arr[*,i]          = GEI2VDH_vec[*,*,i]    # B_GEI_arr[*,i]

     ;;... And, TESTS. These should come out the same:
     GEOPACK_BSPCAR_08  ,pos_theta_MAG,pos_phi_MAG, $
                         vel_MAGSph_arr[0,i],vel_MAGSph_arr[1,i],vel_MAGSph_arr[2,i], $
                         testVelx_MAG,testVely_MAG,testVelz_MAG,/DEGREE ; ,EPOCH=time_epoch[i]
     GEOPACK_BCARSP_08  ,pos_gsm_xyz_R_E[0],pos_gsm_xyz_R_E[1],pos_gsm_xyz_R_E[2], $
                         vel_MAG_arr[0,i],vel_MAG_arr[1,i],vel_MAG_arr[2,i], $
                         testVelr_MAG,testVeltheta_MAG,testVelphi_MAG


     velMagCar_GEO           = SQRT(tmpVel_GEO[0]*tmpVel_GEO[0] + $
                                    tmpVel_GEO[1]*tmpVel_GEO[1] + $
                                    tmpVel_GEO[2]*tmpVel_GEO[2])
     velMagSph_GEO           = SQRT(vel_GEO_r*vel_GEO_r + $
                                    vel_GEO_theta*vel_GEO_theta + $
                                    vel_GEO_phi*vel_GEO_phi)

     ;; IF ABS(velMagCar_GEO-velMagSph_GEO) GT 0.0001 THEN STOP ;Precision to the fourth decimal place. This will make it quit.

     conv_velMagSph_MAG      = SQRT(vel_MAGSph_arr[0,i]*vel_MAGSph_arr[0,i] + $
                                    vel_MAGSph_arr[1,i]*vel_MAGSph_arr[1,i] + $
                                    vel_MAGSph_arr[2,i]*vel_MAGSph_arr[2,i])

     conv_velMagCar_MAG      = SQRT(vel_MAG_arr[0,i]*vel_MAG_arr[0,i] + $
                                    vel_MAG_arr[1,i]*vel_MAG_arr[1,i] + $
                                    vel_MAG_arr[2,i]*vel_MAG_arr[2,i])

     convConv_velMagSph_MAG  = SQRT(testVelr_MAG*testVelr_MAG + $
                                    testVeltheta_MAG*testVeltheta_MAG + $
                                    testVelphi_MAG*testVelphi_MAG)

     convConv_velMagCar_MAG  = SQRT(testVelx_MAG*testVelx_MAG + $
                                    testVely_MAG*testVely_MAG + $
                                    testVelz_MAG*testVelz_MAG)

     velMagnitudeDiff        = conv_velMagSph_MAG-conv_velMagCar_MAG
     velSphMagnitudeDiff     = conv_velMagSph_MAG-convConv_velMagSph_MAG
     velCarMagnitudeDiff     = conv_velMagCar_MAG-convConv_velMagCar_MAG

     IF ABS(velMagCar_GEO-velMagSph_GEO) GT 0.001 THEN STOP
     IF ABS(velMagCar_GEO-conv_velMagCar_MAG) GT 0.001 THEN STOP
     IF ABS(velMagSph_GEO-conv_velMagSph_MAG) GT 0.001 THEN STOP

     IF (ABS(velCarMagnitudeDiff) GT 1) OR (ABS(velSphMagnitudeDiff) GT 1) OR (ABS(velMagnitudeDiff) GT 1) THEN STOP

     ;;More tests! Determinants.
     maxDiff = 0.001
     IF ABS(DETERM(GEO2FAC_vec  [*,*,i]) - 1.) GT maxDiff THEN STOP
     IF ABS(DETERM(GEO2FACV_vec [*,*,i]) - 1.) GT maxDiff THEN STOP

     IF ABS(DETERM(GEO2GEI_vec[*,*,i]) - 1.) GT maxDiff THEN STOP
     ;; IF ABS(DETERM(GEO2GEI_vec  [*,*,i]) - 1.) GT maxDiff THEN STOP

     IF ABS(DETERM(GEO2MAG_vec[*,*,i]) - 1.) GT maxDiff THEN STOP
     ;; IF ABS(DETERM(GEO2MAG_vec  [*,*,i]) - 1.) GT maxDiff THEN STOP

     IF ABS(DETERM(GEO2NED_vec[*,*,i]) - 1.) GT maxDiff THEN STOP
     ;; IF ABS(DETERM(GEO2NED_vec  [*,*,i]) - 1.) GT maxDiff THEN STOP

     IF ABS(DETERM(GEI2VDH_vec  [*,*,i]) - 1.) GT maxDiff THEN STOP

     IF (i MOD 100) EQ 0 THEN PRINT,i

     lastPos_x_GEO = pos_x_GEO
     lastPos_y_GEO = pos_y_GEO
     lastPos_z_GEO = pos_z_GEO
  ENDFOR

  ;;Lat, long, height
  GEISph_arr2   = [ $
                  [90.-REFORM(pos_GEISph_arr[0,*])], $
                  [REFORM(pos_GEISph_arr[1,*])], $
                  [REFORM(pos_GEISph_arr[2,*])-R_E] $ ;Convert to latitude from colatitude here
                  ]

  GEOSph_arr2   = [ $
                  [90.-REFORM(pos_GEOSph_arr[0,*])], $
                  [REFORM(pos_GEOSph_arr[1,*])], $
                  [REFORM(pos_GEOSph_arr[2,*])-R_E] $ ;Convert to latitude from colatitude here
                  ]

  MAGSph_arr2   = [ $
                  [90.-REFORM(pos_MAGSph_arr[0,*])], $
                  [REFORM(pos_MAGSph_arr[1,*])], $
                  [REFORM(pos_MAGSph_arr[2,*])-R_E] $ ;Convert to latitude from colatitude here
                  ]

  DIPOLE  = {gsm : {car : {x   : REFORM(IGRF_GSM_DIP_arr[0,*]), $
                           y   : REFORM(IGRF_GSM_DIP_arr[1,*]), $
                           z   : REFORM(IGRF_GSM_DIP_arr[2,*])}}}

  IGRF    = {FAC : {car : {o      : REFORM(IGRF_FAC_arr[0,*]), $
                           e      : REFORM(IGRF_FAC_arr[1,*]), $
                           b      : REFORM(IGRF_FAC_arr[2,*])}}, $
             GEI : {car : {x      : REFORM(IGRF_GEI_arr[0,*]), $
                           y      : REFORM(IGRF_GEI_arr[1,*]), $
                           z      : REFORM(IGRF_GEI_arr[2,*])}}, $
             GEO : {car : {x      : REFORM(IGRF_GEO_arr[0,*]), $
                           y      : REFORM(IGRF_GEO_arr[1,*]), $
                           z      : REFORM(IGRF_GEO_arr[2,*])}, $
                    sph : {theta  : REFORM(IGRF_GEO_sphArr[0,*]), $
                           phi    : REFORM(IGRF_GEO_sphArr[1,*]), $
                           r      : REFORM(IGRF_GEO_sphArr[2,*])}}, $
             GSM : {car : {x      : REFORM(IGRF_GSM_arr[0,*]), $
                           y      : REFORM(IGRF_GSM_arr[1,*]), $
                           z      : REFORM(IGRF_GSM_arr[2,*])}, $
                    sph : {theta  : REFORM(IGRF_GSM_sphArr[0,*]), $
                           phi    : REFORM(IGRF_GSM_sphArr[1,*]), $
                           r      : REFORM(IGRF_GSM_sphArr[2,*])}}, $
             VDH : {car : {v      : REFORM(IGRF_VDH_arr[0,*]), $
                           d      : REFORM(IGRF_VDH_arr[1,*]), $
                           h      : REFORM(IGRF_VDH_arr[2,*])}}}

  B       = {FAC : {car : {o      : REFORM(B_FAC_arr[0,*]), $
                           e      : REFORM(B_FAC_arr[1,*]), $
                           b      : REFORM(B_FAC_arr[2,*])}}, $
             GEI : {car : {x      : REFORM(B_GEI_arr[0,*]), $
                           y      : REFORM(B_GEI_arr[1,*]), $
                           z      : REFORM(B_GEI_arr[2,*])}}, $
             GEO : {car : {x      : REFORM(B_GEO_arr[0,*]), $
                           y      : REFORM(B_GEO_arr[1,*]), $
                           z      : REFORM(B_GEO_arr[2,*])}, $
                    sph : {theta  : REFORM(B_GEO_sphArr[0,*]), $
                           phi    : REFORM(B_GEO_sphArr[1,*]), $
                           r      : REFORM(B_GEO_sphArr[2,*])}}, $
             GSM : {car : {x      : REFORM(B_GSM_arr[0,*]), $
                           y      : REFORM(B_GSM_arr[1,*]), $
                           z      : REFORM(B_GSM_arr[2,*])}, $
                    sph : {theta  : REFORM(B_GSM_sphArr[0,*]), $
                           phi    : REFORM(B_GSM_sphArr[1,*]), $
                           r      : REFORM(B_GSM_sphArr[2,*])}}, $
             VDH : {car : {v      : REFORM(B_VDH_arr[0,*]), $
                           d      : REFORM(B_VDH_arr[1,*]), $
                           h      : REFORM(B_VDH_arr[2,*])}}}

  BDiff = {FAC : {car : {o :B.FAC.car.o-IGRF.FAC.car.o, $
                          e  :B.FAC.car.e-IGRF.FAC.car.e, $
                          b  :B.FAC.car.b-IGRF.FAC.car.b}}, $
            GEI : {car : {x:B.GEI.car.x-IGRF.GEI.car.x, $
                          y:B.GEI.car.y-IGRF.GEI.car.y,  $
                          z:B.GEI.car.z-IGRF.GEI.car.z}}, $
            GEO : {car : {x:B.GEO.car.x-IGRF.GEO.car.x, $
                          y:B.GEO.car.y-IGRF.GEO.car.y, $
                          z:B.GEO.car.z-IGRF.GEO.car.z}, $
                   sph : {theta:B.GEO.sph.theta-IGRF.GEO.sph.theta, $
                          phi:B.GEO.sph.phi-IGRF.GEO.sph.phi, $
                          r:B.GEO.sph.r-IGRF.GEO.sph.r}}, $
            GSM : {car  : {x:B.GSM.car.x-IGRF.GSM.car.x, $
                           y:B.GSM.car.y-IGRF.GSM.car.y, $
                           z:B.GSM.car.z-IGRF.GSM.car.z}, $
                   sph : {theta:B.GSM.sph.theta-IGRF.GSM.sph.theta, $
                          phi:B.GSM.sph.phi-IGRF.GSM.sph.phi, $
                          r:B.GSM.sph.r-IGRF.GSM.sph.r}}, $
            VDH : {car : {v:B.VDH.car.v-IGRF.VDH.car.v, $
                          d:B.VDH.car.d-IGRF.VDH.car.d,  $
                          h:B.VDH.car.h-IGRF.VDH.car.h}}}

  ;;Position struct
  pos      = {GEI : {car : {x     : REFORM(pos_GEI_arr[0,*]), $
                            y     : REFORM(pos_GEI_arr[1,*]), $
                            z     : REFORM(pos_GEI_arr[2,*])}, $
                     sph : {theta : REFORM(pos_GEISph_arr[0,*]), $
                            phi   : REFORM(pos_GEISph_arr[1,*]), $
                            r     : REFORM(pos_GEISph_arr[2,*])}}, $
              GEO : {ALT : alt_GEO, $
                     LON : pos_GEOSph_arr[1,*], $
                     LAT : lat_GEO, $
                     car : {x     : REFORM(pos_GEO_arr[0,*]), $
                            y     : REFORM(pos_GEO_arr[1,*]), $
                            z     : REFORM(pos_GEO_arr[2,*])}, $
                     sph : {theta : REFORM(pos_GEOSph_arr[0,*]), $
                            phi   : REFORM(pos_GEOSph_arr[1,*]), $
                            r     : REFORM(pos_GEOSph_arr[2,*])}}, $
              GSM : {car : {x     : REFORM(pos_GSM_arr[0,*]), $
                            y     : REFORM(pos_GSM_arr[1,*]), $
                            z     : REFORM(pos_GSM_arr[2,*])}, $
                     sph : {theta : REFORM(pos_GSMSph_arr[0,*]), $
                            phi   : REFORM(pos_GSMSph_arr[1,*]), $
                            r     : REFORM(pos_GSMSph_arr[2,*])}}, $
              MAG : {ALT : MAGSph_arr2[*,2], $
                     LON : MAGSph_arr2[*,1], $
                     LAT : MAGSph_arr2[*,0], $
                     car : {x     : REFORM(pos_MAG_arr[0,*]), $
                            y     : REFORM(pos_MAG_arr[1,*]), $
                            z     : REFORM(pos_MAG_arr[2,*])}, $
                     sph : {theta : REFORM(pos_MAGSph_arr[0,*]), $
                            phi   : REFORM(pos_MAGSph_arr[1,*]), $
                            r     : REFORM(pos_MAGSph_arr[2,*])}}, $
              NED : {car : {x     : REFORM(pos_NED_arr[0,*]), $
                            y     : REFORM(pos_NED_arr[1,*]), $
                            z     : REFORM(pos_NED_arr[2,*])}}}

  ;;Velocity struct
  vel     = {FAC : {car : {o     : REFORM(vel_FAC_arr[0,*]), $, $
                           e     : REFORM(vel_FAC_arr[1,*]), $, $
                           b     : REFORM(vel_FAC_arr[2,*])}}, $
             FACV: {car : {a     : REFORM(vel_FACV_arr[0,*]), $, $
                           c     : REFORM(vel_FACV_arr[1,*]), $, $
                           b     : REFORM(vel_FACV_arr[2,*])}}, $
             GEI : {car : {x     : REFORM(vel_GEI_arr[0,*]), $, $
                           y     : REFORM(vel_GEI_arr[1,*]), $, $
                           z     : REFORM(vel_GEI_arr[2,*])}}, $
             GEO : {car : {x     : REFORM(vel_GEO_arr[0,*]), $
                           y     : REFORM(vel_GEO_arr[1,*]), $
                           z     : REFORM(vel_GEO_arr[2,*])}, $
                    sph : {theta : REFORM(vel_GEOSph_arr[1,*]), $
                           phi   : REFORM(vel_GEOSph_arr[2,*]), $
                           r     : REFORM(vel_GEOSph_arr[0,*])}}, $
             MAG : {car : {x     : REFORM(vel_MAG_arr[0,*]), $
                           y     : REFORM(vel_MAG_arr[1,*]), $
                           z     : REFORM(vel_MAG_arr[2,*])}, $
                    sph : {theta : REFORM(vel_MAGSph_arr[0,*]), $
                           phi   : REFORM(vel_MAGSph_arr[1,*]), $
                           r     : REFORM(vel_MAGSph_arr[2,*])}}, $
             NED : {car : {x     : REFORM(vel_NED_arr[0,*]), $, $
                           y     : REFORM(vel_NED_arr[1,*]), $, $
                           z     : REFORM(vel_NED_arr[2,*])}}, $
             VDH : {car : {v     : REFORM(vel_VDH_arr[0,*]), $, $
                           d     : REFORM(vel_VDH_arr[1,*]), $, $
                           h     : REFORM(vel_VDH_arr[2,*])}}}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;make struct
  ;; oerstedCoords = {GEO     : GEO_arr, $
  ;;                MAG     : MAG_arr, $
  ;;                GEI     : GEI_arr, $
  ;;                IGRF    : IGRF_GEO_arr, $
  ;;                CREATED : GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
  ;;                ORIGINATING_ROUTINE: orig_routineName}
  coords = {pos     : pos, $
            vel     : vel, $
            IGRF    : IGRF, $
            B       : B, $
            BDiff   : BDiff, $
            DIPOLE  : DIPOLE, $
            CREATED : GET_TODAY_STRING(/DO_YYYYMMDD_FMT), $
            ORIGINATING_ROUTINE: orig_routineName}

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  ;;Save it
  STOP

  PRINT,'Saving ' + outDir + outFile + '...'
  save,coords,FILENAME=outDir+outFile

  PRINT,"Did it!"

  ;; geocarmagnitude   = SQRT(oersted.ecef.position.x*oersted.ecef.position.x+ $
  ;;                          oersted.ecef.position.y*oersted.ecef.position.y+ $
  ;;                          oersted.ecef.position.z*oersted.ecef.position.z)
  geocarmagnit2     = SQRT(pos.geo.car.x*pos.geo.car.x+pos.geo.car.y*pos.geo.car.y+pos.geo.car.z*pos.geo.car.z)
  ;; geosphmagnitude  = SQRT(geo.sph.r*geo.sph.r+geo.sph.theta*geo.sph.theta+geo.sph.phi*geo.sph.phi)
  geosphmagnitude   = pos.geo.sph.r
  diffgeo           = geosphmagnitude - $
                      geocarmagnit2

  velcarMagnitude   = SQRT(vel.geo.car.x*vel.geo.car.x+vel.geo.car.y*vel.geo.car.y+vel.geo.car.z*vel.geo.car.z)
  velsphMagnitude   = SQRT(vel.geo.sph.r*vel.geo.sph.r+vel.geo.sph.theta*vel.geo.sph.theta+vel.geo.sph.phi*vel.geo.sph.phi)
  ;; velsphMagnitude   = vel.geo.sph.r ;;pff, idiot
  diffVel           = velsphMagnitude- $
                      velcarmagnitude

  bgeosphmagnitude  = SQRT(igrf.geo.sph.r*igrf.geo.sph.r+igrf.geo.sph.theta*igrf.geo.sph.theta+igrf.geo.sph.phi*igrf.geo.sph.phi)
  bgeocarmagnitude  = SQRT(igrf.geo.car.x*igrf.geo.car.x+igrf.geo.car.y*igrf.geo.car.y+igrf.geo.car.z*igrf.geo.car.z)
  bgsmcarmagnitude  = SQRT(igrf.gsm.car.x*igrf.gsm.car.x+igrf.gsm.car.y*igrf.gsm.car.y+igrf.gsm.car.z*igrf.gsm.car.z)
  diffB             = bgeosphmagnitude-bgeocarmagnitude

  magPercentDiffGEO = (bgeosphmagnitude[1:-1]-bgeosphmagnitude[0:-2])/bgeosphmagnitude[1:-1]*100.
  magPercentDiffGSM = (bgsmcarmagnitude[1:-1]-bgsmcarmagnitude[0:-2])/bgsmcarmagnitude[1:-1]*100.

  STOP

  ;;Supposedly the magnetic field is primarily contained in the X-Z (V-H) plane for VDH coordinates. Can we verify that?

  plots             = PLOT(oersted.time,GEOSph_arr2[*,2],XTITLE='Time (s)',YTITLE='Alt (km)')
  

END
