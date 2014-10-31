#' Import functions for external data files.
#' 
#' Each of these functions imports data into a specified enivronment.
#' 
#' @param filename A string pointing to the data file.
#' @param environment The desired enviroment to receive the data.
#' @param options A list of named options
#' @return If import OK, outputs a preview of the imported data 
#' @name Import backends
NULL

#' @rdname import.matlab
rbci.import.matlab <- function(filename, 
                               environment = rbci.env, 
                               options = rbci.env$options) {
  ######## Initial options ########
  sample.rate <- options$sample.rate
  time.start <- options$ts.start # dataset recorded from -100ms to 1000ms
  time.end <- options$ts.end
  multi.cores <- options$core.count # number of cores to use for parallel ops
  
  init.struct <- readMat(this.file)
  init.eeg <- init.struct$eeg[[1]]
  init.tgt <- init.struct$eeg[[3]] # these are unfortunately hardcoded
  
  ###### convert to table format, add column names ######
  init.dt <- as.data.table(melt(init.eeg,
                                varnames = c("Trial","Sample","Channel"),
                                value.name = "Voltage"))
  setnames(init.dt,old=colnames(all.mats.table),
           new=c(colnames(all.mats.table)[1:length(colnames(all.mats.table))-1],
                 "Voltage"))
  
  ###### do target things #######
  all.tgts.table <- as.data.table(melt(all.tgts, 
                                       varnames = c("Trial")))
  setnames(all.tgts.table,old=colnames(all.tgts.table),
           new=c(colnames(all.tgts.table)[1:length(colnames(all.tgts.table))-1],
                 "Class"))
  
  ##### Merge in subject and session names ######
  setkey(all.tgts.table,File)
  setkey(sub.names,File,Subject)
  # all.tgts.table <- merge(all.tgts.table,sub.names, by="File")
  all.tgts.table <- all.tgts.table[sub.names,nomatch=NA]
  
  setkey(all.tgts.table,File)
  setkey(session.nums,File,Session)
  all.tgts.table <- all.tgts.table[session.nums,nomatch=NA]
  # Create non-duplicated trial length (i.e., long count by subject
  all.tgts.table[,all.Trial:= 
                   as.vector(sapply(
                     all.tgts.table[,length(File),by=Subject]$V1,seq_len))]
  
  # join target and voltage tables
  setkey(all.mats.table,File,Trial,Channel,Sample)
  setkey(all.tgts.table,File,Trial)
  erp <- all.tgts.table[all.mats.table,nomatch = NA]
  
  # update trial column
  erp[,Trial:= all.Trial]
  erp[,all.Trial:= NULL]

  # add time column by reference to sample
  time.lookup <- data.table(Sample = seq_len(max(erp$Sample)))
  time.lookup[,Time:= seq(from=time.start,to=time.end,
                          length.out=max(Sample))]
  setkey(time.lookup,Sample)
  setkey(erp,Sample)
  erp <- erp[time.lookup,nomatch=NA]
  
  # Cleanup
  keep(erp,project.root,sample.rate, sure=TRUE)
  gc()
}

matlab_type2_import <- function(invar, opts, ...) {
  
  init.eeg <- init.struct$eeg[[1]]
  init.tgt <- init.struct$eeg[[3]]
  
  all.mats.table <- melt(all.mats, 
                         varnames = c("Trial","Sample","Channel","File"), 
                         value.name = "Voltage")
  
}