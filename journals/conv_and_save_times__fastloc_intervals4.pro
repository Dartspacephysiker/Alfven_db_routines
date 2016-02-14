PRO CONV_AND_SAVE_TIMES,times,filename

  strTimes = TIME_TO_STR(times,/msec)

  print,'saving to ' + filename + '...'
  save,strTimes,FILENAME=filename
END