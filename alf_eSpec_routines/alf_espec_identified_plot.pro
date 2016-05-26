;2016/05/25
;;   X               DOUBLE    Array[25828]
;;   MLT             FLOAT     Array[25828]
;;   ILAT            FLOAT     Array[25828]
;;   MONO            BYTE      Array[25828]
;;   BROAD           BYTE      Array[25828]
;;   DIFFUSE         BYTE      Array[25828]
;;   JE              FLOAT     Array[25828]
;;   JEE             FLOAT     Array[25828]
;;   NBAD_ESPEC      BYTE      Array[25828]
;;   ALF_INDICES     LONG      Array[25828]
;;
FUNCTION ALF_ESPEC_IDENTIFIED_PLOT,alf_eSpec,YLOG=yLog

  names = ['Mono','Broad','Diffuse']

  colors = ['blue','red'] ;not-strict and strict

  locations = [0,1,2]

  monoTemp = WHERE(alf_eSpec.mono EQ 1,mono)
  monoSTemp = WHERE(alf_eSpec.mono EQ 2,monoS)
  broadTemp = WHERE(alf_eSpec.broad EQ 1,broad)
  broadSTemp = WHERE(alf_eSpec.broad EQ 2,broadS)
  diffuseTemp    = WHERE(alf_eSpec.diffuse,diffuse)

  notStrict = [mono,broad,diffuse]
  strict    = [monoS,broadS,0]

                                ; Plot three bars, stacked.
  b1 = BARPLOT(locations,notStrict, $
               YLOG=ylog, $
               FILL_COLOR=colors[0], $
               ;; BOTTOM_COLOR="white", $
               XTICKVALUES=locations, $
               XTICKNAME=names)
  
  b2 = BARPLOT(locations,strict, $
               BOTTOM_VALUES=notStrict, $
               ;; XTICKVALUES=locations, $
               FILL_COLOR=colors[1], $
               ;; BOTTOM_COLOR="white",  $
               /OVERPLOT)
  
  
  text_pine = TEXT(0.1, 0.7, 'Not strict', /CURRENT, $
                   COLOR=colors[0], /NORMAL)
  text_yel = TEXT(0.1, 0.65, 'Strict', /CURRENT, $
                  COLOR=colors[1], /NORMAL)
; Add a title.
  b1.TITLE="Mono, broad, and diffuse e!U-!N statistics for Alf events"
  

  RETURN,[b1,b2]

END