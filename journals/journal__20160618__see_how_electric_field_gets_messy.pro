;2016/06/18
;So it all went wrong somewhere between orb 12670 and orb 12679. That's all I needed to know.
; I use everything up to Nov 3, 1999.
PRO JOURNAL__20160618__SEE_HOW_ELECTRIC_FIELD_GETS_MESSY

  COMPILE_OPT idl2,strictarrsubs

  LOAD_MAXIMUS_AND_CDBTIME,maximus,/DO_DESPUNDB

  outDir = '/SPENCEdata/Research/Satellites/FAST/Alfven_db_routines/plots/'

  SET_PLOT_DIR,plotDir,/FOR_ALFVENDB,/ADD_TODAY

  ;; dbOrbMin = 500
  ;; dbOrbMax = 16361
  ;; orbDelta = 500
  ;; maxCount = 4500

  ;; dbOrbMin = 12500
  ;; dbOrbMax = 13000
  ;; orbDelta = 50
  ;; maxCount = 1000

  ;; dbOrbMin = 12600
  ;; dbOrbMax = 12750
  ;; orbDelta = 50
  ;; maxCount = 500

  ;; dbOrbMin = 12650
  ;; dbOrbMax = 12700
  ;; orbDelta = 25
  ;; maxCount = 250

  ;; dbOrbMin = 12670
  ;; dbOrbMax = 12700
  ;; orbDelta = 10
  ;; maxCount = 200

  ;; dbOrbMin = 12670
  ;; dbOrbMax = 12779
  ;; orbDelta = 10
  ;; maxCount = 200

  nLoops   = (dbOrbMax-dbOrbMin)/orbDelta

  binSize  = 0.1
  minX     = 1
  maxX     = 3.5

  FOR i=0,nLoops DO BEGIN
     minOrb = dbOrbMin+i*orbDelta
     maxOrb = dbOrbMin+(i+1)*orbDelta - 1 < dbOrbMax
     orbStr = STRING(FORMAT='("Orbs_",I0,"-",I0)',minOrb,maxOrb)

     inds   = WHERE(maximus.orbit GE minOrb AND maximus.orbit LE maxOrb)

     outFile = 'Maximus--delta_E_for_'+orbStr+'.png'
     PRINT,'Saving to ' + outFile + ' ...'
     CGHISTOPLOT,ALOG10(ABS(maximus.delta_e[inds])), $
                 TITLE="Delta-E for " + orbStr, $
                 MININPUT=minX, $
                 MAXINPUT=maxX, $
                 OUTPUT=plotDir+outFile, $
                 BINSIZE=binSize, $
                 MIN_VALUE=0, $
                 MAX_VALUE=maxCount


  ENDFOR
END