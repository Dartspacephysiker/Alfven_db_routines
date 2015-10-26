;2015/10/20
;;Some defaults for all of out plots and things

  plotMargin=[0.13, 0.20, 0.13, 0.15]
  defPlotMargin_max=[0.13, 0.1, 0.07, 0.1]

  defNegColor                = 'green'
  defPosColor                = 'red'

  defSymTransp               = 97
  defLineTransp              = 75
  defLineThick               = 2.5
                             
  ;;defs for maxPlots        
  max_xtickfont_size=20      
  max_xtickfont_style=1      
  max_ytickfont_size=20      
  max_ytickfont_style=1      
  avg_symSize=2.0            
  avg_symThick=2.0           
  avg_Thick=2.5              
                             
  max_scatter_symbol         = '+'
  max_scatter_color          = 'r'
  defXTitle                  = 'Hours since center UTC'
                             
  ;;For averages/sums epoch plots
  defAvgSym                  = 'd'
  defAvgSymSize              = 2.5
  defAvgSymColor             = 'MAROON'
  defAvgSymLinestyle         = '--'
  defAvgLineThick            = 2.0
  defAvgSymAxisStyle         = 2
  defAvgPlotName             = 'alf_utc_avgsum'

  ;; ;For histos             
  defnEvBinsize              = 150.0D                                                                        ;in minutes
  defnEvYRange               = [0,5000]
  defHistoName               = 'Event histogram'                       
  defHistoYticksize          = max_ytickfont_size
  defHistoYtickfontstyle     = max_ytickfont_style
  defHistoColor              = 'red'
  defHistoTickFormat         = '(I0)'
  defHistoRange              = [0,7500]
  defHistoThick               = 6.5

  defBkgrndHistoName         = 'Background histogram'
  defBkgrndHistoColor        = 'blue'
  defBkgrndTransp            = 50
  ;; nMajorTicks=5
  ;; nMinorTicks=3
  nMajorTicks=5
  nMinorTicks=2
  
  ;;For showing data availability
  defShowSymbol              = 'tu'
  defShowSymSize             = 2.0
  defRes = 200
