;2017/07/13
;; FUNCTION TRASH_EVENTS_NEAR_SSC,dbStruct,good_i, $
PRO TRASH_EVENTS_NEAR_SSC,dbStruct,good_i, $
                               DBTIMES=DBTimes, $
                               REMAKE_TRASHSSC_FILES=remake_trashSSC_files

  COMPILE_OPT IDL2,STRICTARRSUBS

  PRINT,"Trashing events near SSC"
  ;; nGStart = N_ELEMENTS(good_i)
  ;; nGStart = N_ELEMENTS(dbStruct.(0))
  nBTot   = 0

  dirForAlle = '/SPENCEdata/Research/database/temps/'

  ;; kill all before minutesBef minutes
  minutesBef = 15
  ;; kill all before minutesAft minutes
  minutesAft = 45

  ;; remake_trashSSC_files       = N_ELEMENTS(remake_trashSSC_files) GT 0 ? remake_trashSSC_files : 1

  ;;Can we?
  use_x = 0B
  IF ~KEYWORD_SET(DBTimes) THEN BEGIN

     use_x = TAG_EXIST(dbStruct,'x')

     IF ~use_x THEN BEGIN
        PRINT,"You have no right to be in this house."
        STOP
     ENDIF
  ENDIF

  ;;See if we have somesing first
  blackballFile = dirForAlle + GET_FAST_DB_STRING(dbStruct) + '-blackballSSC.sav'

  goAhead = 1
  IF FILE_TEST(blackballFile) AND ~KEYWORD_SET(remake_trashSSC_files) THEN BEGIN
     PRINT,'Restoring blackballFile: ' + blackballFile + ' ...'
     RESTORE,blackballFile
     IF (rMinutesBef EQ minutesBef) AND $
        (rMinutesAft EQ minutesAft)     $
     THEN BEGIN
        ;; blackBall_ii        = TEMPORARY(rblackBall_ii       )
        ;; keeper_ii           = TEMPORARY(rkeeper_ii          )
        blackBall_i         = TEMPORARY(rblackBall_i        )
        keeper_i            = TEMPORARY(rkeeper_i           )
        nKeeper             = TEMPORARY(rNKeeper            )
        nBlackball          = TEMPORARY(rNBlackball         )
        minutesBef          = TEMPORARY(rMinutesBef         )
        minutesAft          = TEMPORARY(rMinutesAft         )

        goAhead             = 0

     ENDIF
  ENDIF

  IF goAhead OR KEYWORD_SET(remake_trashSSC_files) THEN BEGIN

     DBDir        = '/home/spencerh/Research/database/storm_data/'
     DB_NOAA      = 'SSC_dbs--storm2_mods.txt__STORM2_MODS.SSC--idl.sav'

     IF FILE_TEST(DBDir+DB_NOAA) THEN RESTORE,DBDir+DB_NOAA ELSE BEGIN
        PRINT,"WHERE IS IT!?"
        STOP
     ENDELSE

     SSCs_UTC = JULDAY_TO_UTC(ssc1.julDay[WHERE(ssc1.year GT 1970)])

     ;; firstInd = VALUE_LOCATE(blackballOrb_ranges[0,*],dbStruct.orbit)

     checkMeOut  = VALUE_CLOSEST2(SSCs_UTC,(use_x ? dbStruct.x : DBTimes),/CONSTRAINED)

     blackBall_i = WHERE( ( ABS( SSCs_UTC[checkMeOut] - (use_x ? dbStruct.x : DBTimes) ) LE minutesBef*60. AND $
                               ( SSCs_UTC[checkMeOut] - (use_x ? dbStruct.x : DBTimes) ) GE 0                  ) OR $
                          ( ABS( (use_x ? dbStruct.x : DBTimes) - SSCs_UTC[checkMeOut] ) LE minutesAft*60. AND $
                               ( (use_x ? dbStruct.x : DBTimes) - SSCs_UTC[checkMeOut] ) GE 0                  ), $
                         nBlackball, $
                         COMPLEMENT=keeper_i, $
                         NCOMPLEMENT=nKeeper)

     rblackBall_i         = blackBall_i
     rkeeper_i            = keeper_i
     rNKeeper             = nKeeper
     rNBlackball          = nBlackball
     rMinutesBef          = minutesBef
     rMinutesAft          = minutesAft

     PRINT,"Saving blackballSSC stuff to " + blackballFile + ' ...'
     SAVE,rblackBall_i,rkeeper_i,rNKeeper,rNBlackball,rMinutesBef,rMinutesAft,FILENAME=blackballFile

     rblackBall_i         = !NULL
     rkeeper_i            = !NULL
     rNKeeper             = !NULL
     rNBlackball          = !NULL
     rMinutesBef          = !NULL
     rMinutesAft          = !NULL

  ENDIF

  IF nBlackball GT 0 THEN BEGIN
     nGood   = N_ELEMENTS(good_i)
     good_i  = CGSETDIFFERENCE(good_i,blackball_i,COUNT=nKeeper,NORESULT=-1)

     ;; nGood   = N_ELEMENTS(dbStruct.(0))
     ;; good_i  = CGSETDIFFERENCE(good_i,blackball_i,COUNT=nKeeper,NORESULT=-1)

     nBTot  += nBlackball

     IF good_i[0] EQ -1 THEN BEGIN
        PRINT,opener+"We've killed everything!"
        broken = 1
     ENDIF
     opener = ''
     PRINT,opener+'Junked ' + STRCOMPRESS(nGood-nKeeper,/REMOVE_ALL) + ' blackballed (SSC) events ...'
  ENDIF ELSE BEGIN
     PRINT,opener+"No baddies found in this case ..."
  ENDELSE

  IF KEYWORD_SET(broken) THEN STOP

  IF KEYWORD_SET(remake_trashSSC_files) THEN BEGIN
     PRINT,"Switching off REMAKE_TRASHSSC_FILES ..."
     remake_trashSSC_files = 0
  ENDIF

  ;; RETURN,good_i

END
