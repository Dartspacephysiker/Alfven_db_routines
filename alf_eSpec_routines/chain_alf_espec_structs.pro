;2016/05/25
PRO CHAIN_ALF_ESPEC_STRUCTS,bigStruct,littleStruct
  
  IF N_ELEMENTS(bigStruct) EQ 0 THEN BEGIN
     bigStruct = { x:littleStruct.x, $  
                   MLT:littleStruct.mlt, $
                   ILAT:littleStruct.ilat, $
                   mono:littleStruct.mono, $ 
                   broad:littleStruct.broad, $
                   diffuse:littleStruct.diffuse, $
                   Je:littleStruct.Je, $
                   Jee:littleStruct.Jee, $
                   nBad_eSpec:littleStruct.nBad_eSpec, $
                   alf_indices:littleStruct.alf_indices}
  ENDIF ELSE BEGIN
     bigStruct = { x:[bigStruct.x,littleStruct.x], $
                   MLT:[bigStruct.mlt,littleStruct.mlt], $
                   ILAT:[bigStruct.ilat,littleStruct.ilat], $
                   mono:[bigStruct.mono,littleStruct.mono], $
                   broad:[bigStruct.broad,littleStruct.broad], $
                   diffuse:[bigStruct.diffuse,littleStruct.diffuse], $
                   Je:[bigStruct.Je,littleStruct.Je], $
                   Jee:[bigStruct.Jee,littleStruct.Jee], $
                   nBad_eSpec:[bigStruct.nBad_eSpec,littleStruct.nBad_eSpec], $
                   alf_indices:[bigStruct.alf_indices,littleStruct.alf_indices]}
  ENDELSE



END