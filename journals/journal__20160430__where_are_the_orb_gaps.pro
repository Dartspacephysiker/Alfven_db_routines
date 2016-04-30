;2016/04/30 Based on what I see here, it's time to run the latest ALFVEN_STATS_5--the one that properly checks for
;data--starting at orbit 8436
PRO JOURNAL__20160430__WHERE_ARE_THE_ORB_GAPS

  LOAD_MAXIMUS_AND_CDBTIME,maximus

  uniq_orbs=maximus.orbit[UNIQ(maximus.orbit)]

  orbDiff=SHIFT(uniq_orbs,-1)-uniq_orbs

  bigDiff = WHERE(orbDiff GT 5,bigCount)
  FOR i=0,bigCount-1 DO BEGIN
     PRINT,uniq_orbs[bigDiff[i]],orbDiff[bigDiff[i]]
  ENDFOR


END

;The list
  ;;    1545      10
  ;;    2492       8
  ;;    2910      16
  ;;    3498       6
  ;;    3509       6
  ;;    3539       6
  ;;    3626       6
  ;;    7797       7
  ;;    8135       6
  ;;    8436      42
  ;;    9354       7
  ;;    9365       8
  ;;   10155       7
  ;;   10209      11
  ;;   10227       6
  ;;   10233      10
  ;;   10266       6
  ;;   10280      11
  ;;   10294      14
  ;;   10319      10
  ;;   10361       7
  ;;   10465       6
  ;;   10471       8
  ;;   10683       7
  ;;   10690      11
  ;;   10714      11
  ;;   10734       8
  ;;   10758       6
  ;;   10770       6
  ;;   11449       6
  ;;   11688      22
  ;;   11747       6
  ;;   12036       6
  ;;   12060       6
  ;;   12070       7
  ;;   12097       6
  ;;   12393       6
  ;;   13211       8
  ;;   13537       8
  ;;   14703       6
  ;;   15075      23
  ;;   15183      18
  ;;   15202       8
  ;;   15212      14
  ;;   15227      27
  ;;   15254      28
  ;;   15286      10
  ;;   15297      17
  ;;   15315      40
  ;;   15356      16