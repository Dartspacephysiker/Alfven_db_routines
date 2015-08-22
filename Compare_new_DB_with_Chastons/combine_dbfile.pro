pro combine_dbfile,is_as3,dat,in_name=in, outname=out

;;  in_name=fname[0]
  print, "File: " + in

  result=in

;  result=file_which('./',in_name)
  if result then begin
;     result=file_which('./',in_name)
;     if result then begin
     print,is_as3
     CASE is_as3 OF
      0: BEGIN
        rdf_dflux_fout_as5,result,dat,out 
        restore, out
        save, dat,filename=out
        END
      1: BEGIN
        rdf_dflux_fout,result,dat,out
        restore, out
        save, dat, filename=out
        END
      ELSE: PRINT, "WHAT HAVE YOU DONE?! RDF_FLUX_OUT WILL NEVER BE ABLE TO HANDLE THIS!" 
     ENDCASE
  endif
  
print, 'Saved ' + out


  return

end
