;2016/03/21
FUNCTION SPLIT_IND_LIST_INTO_ORB_STRUCTARR_LIST,i_list,maximus

  orbStrArr_list = LIST()

  FOR i=0,N_ELEMENTS(i_list)-1 DO BEGIN
     CHECK_SORTED,i_list[i],is_sorted,SORTED_I=sort_i
     IF ~is_sorted THEN BEGIN
        PRINT,'Not sorted! Sorting...'
           i_list[i] = i_list[i,sort_i]
        ENDIF
     
     temp_i = i_list[i]
     
     orbNums  = maximus.orbit[temp_i[UNIQ(maximus.orbit[temp_i])]]
     
     orbStrArr = !NULL
     FOR j=0,N_ELEMENTS(orbNums)-1 DO BEGIN
        plot_i       = temp_i[WHERE(maximus.orbit[temp_i] EQ orbNums[j])]
        IF plot_i[0] NE -1 THEN BEGIN
           orbStr       = {ORBIT:orbNums[j], $
                           PLOT_I_LIST:LIST(plot_i), $
                           N:N_ELEMENTS(plot_i), $
                           COLOR:FIX(255*RANDOMU(seed,3)) $
                          }
           orbStrArr = [orbStrArr,orbStr]
        ENDIF
     ENDFOR
     orbStrArr_list.add,orbStrArr
  ENDFOR
  
  RETURN,orbStrArr_list
  
END