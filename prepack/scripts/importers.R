#' Import functions for external data files.
#' 
#' @param filename A string pointing to the data file.
#' @param environment The desired enviroment to receive the data.
#' @param ... A list of named options
#' @return If import OK, outputs a preview of the imported data 
#' @name Import backends
NULL

#' @rdname import.matlab
rbci.import.matlab <- function(filename, environment = rbci.env, options) {
  sample.rate <- 512 # 512Hz for AUTD dataset
  time.start <- -100 # dataset recorded from -100ms to 1000ms
  time.end <- 999
  multi.cores <- 3 # number of cores to use for parallel ops
  
  # read in each mat-file; pull targets and voltages into arrays
  all.mats <- foreach(this.file = filelist, .combine=myabind) %dopar% {
    init.struct <- readMat(this.file)
    init.eeg <- init.struct$eeg[[1]]
    return(init.eeg)
  }
  all.tgts <- foreach(this.file = filelist, .combine=cbind) %dopar% {
    init.struct <- readMat(this.file)
    init.tgt <- init.struct$eeg[[3]] # these are unfortunately hardcoded
    return(init.tgt)
  }
  
  # get subject names from each file
  sub.names <- foreach(this.file = filelist, .combine=c) %do% {
    this.sub <- substr(this.file,1,3)
  }
  
  # convert to table format, add column names
  all.mats.table <- melt(all.mats, 
                         varnames = c("Trial","Sample","Channel","File"), 
                         value.name = "Voltage")
  all.mats.table <- as.data.table(all.mats.table)
  setnames(all.mats.table,old=colnames(all.mats.table),
           new=c(colnames(all.mats.table)[1:length(colnames(all.mats.table))-1],
                 "Voltage"))
  
  all.tgts.table <- melt(all.tgts, varnames = c("Trial","File"))
  all.tgts.table <- as.data.table(all.tgts.table)
  setnames(all.tgts.table,old=colnames(all.tgts.table),
           new=c(colnames(all.tgts.table)[1:length(colnames(all.tgts.table))-1],
                 "Class"))
  
  # Merge in subject and session names
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
  
  # add subject column by reference to file index
  # erp <- merge(erp,sub.names, by="File")
  # setkey(erp,File)
  # setkey(sub.names,File)
  # erp.t <- sub.names[erp]
  
  # drop file index
  erp[,File:= NULL]
  # drop duplicated columns
  # erp[,Subject:= Subject.x]
  # erp[,Subject.x:= NULL]
  # erp[,Subject.y:= NULL]
  
  # Cleanup
  keep(erp,project.root,sample.rate, sure=TRUE)
  gc()
}