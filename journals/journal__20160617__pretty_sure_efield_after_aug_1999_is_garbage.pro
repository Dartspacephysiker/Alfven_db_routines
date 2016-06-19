;2016/06/17 See for yourself. It's bogus
PRO JOURNAL__20160617__PRETTY_SURE_EFIELD_AFTER_AUG_1999_IS_GARBAGE

  LOAD_MAXIMUS_AND_CDBTIME,maximus,/DO_DESPUNDB

  inds = CGSETINTERSECTION(GET_CHASTON_IND(maximus,HEMI='BOTH'),WHERE(maximus.orbit LT 11645),count=nInds)

  gtinds = CGSETINTERSECTION(GET_CHASTON_IND(maximus,HEMI='BOTH'),WHERE(maximus.orbit GE 11645),count=nInds)

  CGHISTOPLOT,ALOG10(ABS(maximus.delta_e[inds])), $
              TITLE='Delta_E for orbs LT 11645', $
              OUTPUT='20160617--delta_e--orbs_lt_11645.png'

  CGHISTOPLOT,ALOG10(ABS(maximus.delta_e[gtinds])), $
              TITLE='Delta_E for orbs GE 11645', $
              OUTPUT='20160617--delta_e--orbs_ge_11645.png'

  CGHISTOPLOT,ALOG10(ABS(maximus.delta_e[inds])),TITLE='Delta_E for orbs LT 11645'
  CGHISTOPLOT,ALOG10(ABS(maximus.delta_e[gtinds])),TITLE='Delta_E for orbs GE 11645'


END