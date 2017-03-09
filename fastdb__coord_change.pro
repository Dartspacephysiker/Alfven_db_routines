;;12/09/16
;;Unfinished
PRO FASTDB__COORD_CHANGE, $
   COORDSTRNAME=coordStrName, $
   COORDINATE_SYSTEM=coordinate_system, $
   USE_AACGM_COORDS=use_aacgm, $
   USE_GEO_COORDS=use_geo, $
   USE_MAG_COORDS=use_mag, $
   USE_SDT_COORDS=use_SDT

  COMPILE_OPT IDL2,STRICTARRSUBS

  IF KEYWORD_SET(coordinate_system) THEN BEGIN
     CASE STRUPCASE(coordinate_system) OF
        'AACGM': BEGIN
           use_aacgm = 1
           use_geo   = 0
           use_mag   = 0
           use_SDT   = 0
        END
        'GEO'  : BEGIN
           use_aacgm = 0
           use_geo   = 1
           use_mag   = 0
           use_SDT   = 0
        END
        'MAG'  : BEGIN
           use_aacgm = 0
           use_geo   = 0
           use_mag   = 1
           use_SDT   = 0
        END
        'SDT'  : BEGIN
           use_aacgm = 0
           use_geo   = 0
           use_mag   = 0
           use_SDT   = 1
        END
     ENDCASE
  ENDIF

END
