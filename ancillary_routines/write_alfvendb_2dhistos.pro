;;2015/10/21 maximus and plot_i are only needed for ascii
PRO WRITE_ALFVENDB_2DHISTOS,MAXIMUS=maximus,PLOT_I=plot_i, $
                            CENTERS_MLT=centersMLT, $
                            CENTERS_ILAT=centersILAT, $
                            WRITEHDF5=writeHDF5, $
                            WRITEPROCESSEDH2D=WRITEPROCESSEDH2D, $
                            WRITEASCII=writeASCII, $
                            H2DSTRARR=h2dStrArr, $
                            DATARAWPTRARR=dataRawPtrArr, $
                            DATANAMEARR=dataNameArr, $
                            PARAMSTRING=paramString, $
                            TXTOUTPUTDIR=txtOutputDir


  CASE SIZE(paramString,/TYPE) OF
    11: BEGIN
       tmpParamStrings = paramString
    END
    ELSE: BEGIN
       IF N_ELEMENTS(paramString) EQ 1 THEN BEGIN
          tmpParamStrings = REPLICATE(paramString,N_ELEMENTS(dataNameArr))
       ENDIF ELSE BEGIN
          tmpParamStrings = paramString
       ENDELSE
    END
  ENDCASE

   ;;********************************************************
   ;;Thanks, IDL Coyote--time to write out lots of data
   IF KEYWORD_SET(writeHDF5) THEN BEGIN 
      ;;write out raw data here
      FOR j=0,N_ELEMENTS(h2dStrArr)-2 DO BEGIN 
         fname       = txtOutputDir + dataNameArr[j]+tmpParamStrings[j]+'.h5' 
         PRINT,"Writing HDF5 file: " + fname 
         fileID      = H5F_CREATE(fname) 
         datatypeID  = H5T_IDL_CREATE(h2dStrArr[j].data) 
         dataspaceID = H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
         datasetID   = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
         H5D_WRITE,datasetID,h2dStrArr[j].data 
         H5F_CLOSE,fileID 
      ENDFOR 

      ;;To read your newly produced HDF5 file, do this:
      ;;s = H5_PARSE(fname, /READ_DATA)
      ;;HELP, s.mydata._DATA, /STRUCTURE  
      IF KEYWORD_SET(writeProcessedH2D) THEN BEGIN 
         FOR j=0, N_ELEMENTS(h2dStrArr)-2 DO BEGIN 
            fname       = txtOutputDir + dataNameArr[j]+tmpParamStrings[j]+'.h5' 
            PRINT,"Writing HDF5 file: " + fname 
            fileID      = H5F_CREATE(fname) 
            
            ;;    datatypeID=H5T_IDL_CREATE() 
            dataspaceID = H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID   = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID,h2dStrArr[j].data 
            
            datatypeID  = H5T_IDL_CREATE(h2dStrArr[j].data) 
            dataspaceID = H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID   = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID,h2dStrArr[j].data     
            
            
            datatypeID  = H5T_IDL_CREATE(h2dStrArr[j].data) 
            dataspaceID = H5S_CREATE_SIMPLE(SIZE(h2dStrArr[j].data,/DIMENSIONS)) 
            datasetID   = H5D_CREATE(fileID,dataNameArr[j], datatypeID, dataspaceID) 
            H5D_WRITE,datasetID,h2dStrArr[j].data 
            H5F_CLOSE,fileID 
         ENDFOR 
      ENDIF 
   ENDIF

   IF KEYWORD_SET(writeASCII) THEN BEGIN 
      ;;These are the "raw" data, just as we got them from Chris
      FOR j=0,N_ELEMENTS(dataNameArr)-3 DO BEGIN 
         fname = txtOutputDir + dataNameArr[j]+tmpParamStrings[j]+'.ascii' 
         PRINT,"Writing ASCII file: " + fname 
         OPENW,lun2, fname, /GET_LUN 

         FOR i=0, N_ELEMENTS(plot_i) - 1 DO BEGIN 
            PRINTF,lun2,(maximus.ILAT[plot_i])[i],(maximus.MLT[plot_i])[i],$
                   (*dataRawPtrArr[j])[i],$
                   FORMAT='(F7.2,1X,F7.2,1X,F7.2)' 
         ENDFOR 
         CLOSE, lun2   
         FREE_LUN, lun2 
      ENDFOR 
      
   ENDIF

   ;;NOW DO PROCESSED H2D DATA 
   IF KEYWORD_SET(writeProcessedH2D) THEN BEGIN 
      FOR i=0,N_ELEMENTS(h2dStrArr)-1 DO BEGIN 
         fname = txtOutputDir + "h2d_"+dataNameArr[i]+tmpParamStrings[i]+'.ascii' 
         PRINT,"Writing ASCII file: " + fname 
         OPENW,lun2, fname, /GET_LUN 
         FOR j=0,N_ELEMENTS(centersMLT[*,0])-1 DO BEGIN 
            FOR k=0, N_ELEMENTS(centersILAT[0,*])-1 DO BEGIN 
               PRINTF,lun2,centersILAT[j,k],$
                      centersMLT[j,k],$
                      (h2dStrArr[i].data)[j,k],$
                      FORMAT='(F-10.2,1X,F-10.2,1X,G10.2)' 
            ENDFOR 
         ENDFOR 
         CLOSE, lun2   
         FREE_LUN, lun2 
      ENDFOR 
   ENDIF 

END