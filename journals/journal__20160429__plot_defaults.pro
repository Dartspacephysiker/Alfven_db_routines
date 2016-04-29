  ;;MLT params and stuff
  minM                  = [06.0,-6.0]
  maxM                  = [18.0,06.0]
  hemi                  = 'NORTH'
  ptRegion              = ['Dayside','Nightside']
  psRegion              = ['dayside','nightside']
  symColor              = ['red','blue']
  ;; ptRegion              = ['Both sides','Dayside','Nightside']
  ;; psRegion              = ['bothSides','dayside','nightside']
  ;; symColor              = ['black','red','blue']

  ;;Do a running logAvg window
  running_logAvg        = 20
  running_bin_spacing   = 2   ;spaced 5 hours apart
  running_bin_r_offset  = 0.00

  pref                  = 'journal_20160429--SEA_seasons'
  plotSuff              = '--2-hr_spacing--no_smoothing--north_hemi--despun_db.png'

  ;;strings 'n' things
  ;; fancy_plotNames   = 1
  @fluxplot_defaults
