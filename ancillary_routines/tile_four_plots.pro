;2016/01/01
;It's way better to see all plots together, of course
PRO TILE_FOUR_PLOTS,filenames,titles, $
                     OUT_IMGS=out_imgs, $
                     OUT_TITLEOBJS=out_titleObjs, $
                     COMBINED_TO_BUFFER=combined_to_buffer, $
                     SAVE_COMBINED_WINDOW=save_combined_window, $
                     SAVE_COMBINED_NAME=save_combined_name, $
                     PLOTDIR=plotDir, $
                     DELETE_PLOTS_WHEN_FINISHED=delete_plots, $
                     LUN=lun

  IF N_ELEMENTS(lun) EQ 0 THEN lun = -1 ;stdout
                          
  ;; nImages        = N_ELEMENTS(filenames)
  nImages        = 4

  imHDim         = 1600
  imVDim         = 960
  xRange         = [200,1600]
  yRange         = [40,960]

  IF KEYWORD_SET(combined_to_buffer) THEN BEGIN
     hDim        = 1600
     vDim        = 960

     scaleFactor = 0.2
  ENDIF ELSE BEGIN
     hDim        = 400
     vDim        = 320
     scaleFactor = 0.5
  ENDELSE

  ;; adjHDim     = hDim-200*scaleFactor
  ;; adjVDim     = vDim-40*scaleFactor
  adjHDim     = (xRange[1]-xRange[0])*scaleFactor
  adjVDim     = (yRange[1]-yRange[0])*scaleFactor
  ;; adjHDim     = hDim*scaleFactor
  ;; adjVDim     = vDim*scaleFactor
  ;; img_loc     = [150*scaleFactor,0]
  img_loc     = [0,0]

  ;; xRange      = [150*scaleFactor,650*scaleFactor]
  ;; yRange      = [0,600*scaleFactor]

  imArr       = MAKE_ARRAY(nImages,/OBJ)
  win         = WINDOW(DIMENSIONS=[adjHDim*2,adjVDim*2], $
                       BUFFER=combined_to_buffer)
  titleObjs   = MAKE_ARRAY(nImages,/OBJ)
  
  
  tempNameArr = !NULL
  FOR i = 0,nImages-1 DO BEGIN

     tempName = 'temp' + STRCOMPRESS(i,/REMOVE_ALL) + '.png'
     SPAWN,'mv ' + filenames[i] + ' ' + tempName
     tempNameArr = [tempNameArr,tempName]

     ;; IF ~FILE_TEST(filenames[i]) THEN BEGIN
     ;;    PRINTF,lun,"Couldn't find " + filenames[i] + "! Not tiling these guys..."
     ;;    RETURN
     ;; ENDIF
     IF ~FILE_TEST(tempNameArr[i]) THEN BEGIN
        PRINTF,lun,"Couldn't find " + tempNameArr[i] + "! Not tiling these guys..."
        RETURN
     ENDIF
  ENDFOR

 ;; FOR i = 0, N_ELEMENTS(fileNames) - 1 DO BEGIN
  FOR i = 0,nImages-1 DO BEGIN
     ;; IF KEYWORD_SET(combined_to_buffer) THEN BEGIN
     ;;    imArr[0]    = IMAGE(filenames[i], $
     ;;                        LAYOUT=[3,1,i+1],$
     ;;                        MARGIN=0, $
     ;;                        /BUFFER, $
     ;;                        IMAGE_DIMENSIONS=[hDim,vDim])
     ;; ENDIF ELSE BEGIN
        imArr[i]    = IMAGE(tempNameArr[i], $
                            LAYOUT=[2,2,i+1],$
                            MARGIN=0, $
                            /CURRENT, $
                            ;; DIMENSIONS=[hDim,vDim], $
                            ;; IMAGE_DIMENSIONS=[adjHDim,adjVDim], $
                            DIMENSIONS=[adjHDim,adjVDim], $
                            IMAGE_DIMENSIONS=[imHDim,imVDim], $
                            ;; IMAGE_LOCATION=img_loc, $
                            ;; XRANGE=xRange, $
                            YRANGE=yRange)
     ;; ENDELSE

     IF KEYWORD_SET(titles) THEN BEGIN
        ;; titleObjs[i] = TEXT(i*hDim + hDim/2., vDim*8./9., titles[i], $
        titleObjs[i] = TEXT(i*adjHDim + adjHDim/2., $
                            500, $;adjVDim*8./9., $
                            titles[i], $
                            ALIGNMENT=0.5, $
                            /DEVICE, $
                            FONT_SIZE=20.*scaleFactor)
     ENDIF
  ENDFOR
  
  IF KEYWORD_SET(save_combined_window) THEN BEGIN
     IF ~KEYWORD_SET(plotDir) THEN plotDir = './'
     IF ~KEYWORD_SET(save_combined_name) THEN save_combined_name = plotDir + 'combined_stormphases.png'

     CD,plotDir,CURRENT=oldDir
     win.save,save_combined_name
     PRINT,"Saved " + save_combined_name + "..."
     CD,oldDir
  ENDIF

  ;;for memory's sake
  win.close

  ;;This is handled by win.close
  ;; FOR i = 0,nImages-1 DO BEGIN
  ;;    imArr[i].close    
  ;; ENDFOR

  out_imgArr    = imArr
  out_titleObjs = titleObjs

  IF KEYWORD_SET(delete_plots) THEN BEGIN
     PRINTF,lun,"Deleting plots after tiling..."
     FOR i = 0,nImages-1 DO BEGIN
        PRINTF,lun,'Removing ' + tempNameArr[i] + '...'
        SPAWN,'rm ' + tempNameArr[i]
     ENDFOR
  ENDIF

END