PRO GENERATE_MISSING_ESPEC_ORBS_OUTPUT,cdbTime,orbArr,firstOrb,lastOrb,missingOrbArr, $
                                 Newell_DB_dir,Newell_filePref

  missingOrbArr      = !NULL
  curInterval        = 0

  FOR curOrb=firstOrb,lastOrb DO BEGIN
     
     ;;Get events in this orb
     temp_i          = WHERE(orbArr EQ curOrb,nHere)
     IF temp_i[0] EQ -1 THEN BEGIN
        PRINT,"No events for orbit " + STRCOMPRESS(curOrb,/REMOVE_ALL) + '!!!' 
        CONTINUE
     ENDIF

     ;;First, cat all eSpecs from each interval for this orbit
     tempFile        = STRING(FORMAT='(A0,A0,I0,"_",I0,".sav")',Newell_DB_dir,Newell_filePref,curOrb,curInterval)
     IF ~FILE_TEST(tempFile) THEN BEGIN

        missingOrbArr = [[missingOrbArr],[curOrb,nHere]]

        PRINT,FORMAT='("MISSING ORBIT: ",I0,". (Resulting N events lost: ",I0,")")',curOrb,nHere
     ENDIF

  ENDFOR  

END