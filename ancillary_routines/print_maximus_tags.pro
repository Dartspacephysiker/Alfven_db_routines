PRO PRINT_MAXIMUS_TAGS,maximus

  mt     = TAG_NAMES(maximus)
  FOR i=0,N_ELEMENTS(mt)-1 DO PRINT,FORMAT='(I3,T5,A0,T35,G15.5)',i,mt[i]

END