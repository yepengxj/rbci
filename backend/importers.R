#' Import functions for external data files.
#' 
#' Each of these functions imports data into a specified enivronment.
#' 
#' @param filename A string pointing to the data file.
#' @param environment The desired enviroment to receive the data.
#' @param options A list of named options
#' @return If import OK, outputs a preview of the imported data 
#' @name Import backends

#' @rdname matlab.type2.import
matlab_type2_import <- function(init.struct,eeg.ind,tgt.ind,preview = FALSE) {
  
  # TODO remove structural hardcoding to frontend
  init.eeg <- init.struct$eeg[[eeg.ind]]
  init.tgt <- init.struct$eeg[[tgt.ind]]
  
  eeg.table <- melt(init.eeg,
                    varnames = c("Trial","Sample","Channel"),
                    value.name = "Voltage")
  eeg.table <- as.data.table(eeg.table)
  
  
  eeg.table[,Class:=init.tgt]
  
  return(eeg.table)
}
