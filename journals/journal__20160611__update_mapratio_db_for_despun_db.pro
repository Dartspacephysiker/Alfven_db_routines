;;2016/06/11 Crud, I can't believe I forgot to update this
PRO JOURNAL__20160611__UPDATE_MAPRATIO_DB_FOR_DESPUN_DB

  RESTORE,'/SPENCEdata/Research/database/FAST/dartdb/saves/Dartdb_20160507--2500-3599_and_bonus_despun--maximus--pflux--lshell--noDupes.sav'

  OPENW,lun,'~/Desktop/orbs_to_do_for_mapratio.txt',/GET_LUN				       
  these = UNIQ(maximus.orbit,SORT(maximus.orbit))					       
  ALSO = [10220:16361]									       
  FOR i=0,N_ELEMENTS(these)-1 DO PRINTF,lun,maximus.orbit[these[i]]			       
  FOR i=0,N_ELEMENTS(also)-1 DO PRINTF,lun,also[i]					       
  CLOSE,lun										       
  FREE_LUN,lun									       

END