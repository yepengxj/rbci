##### time-series downsampling #####
downsample.dt <- function(input.table, time.col = "Time", ds.factor = 0.5) {
  # sort first
  setkeyv(input.table,time.col)
  # produce indices of proper downsampled interval length
  resample.seq <- 
   seq(to=input.table[,length(unique(get(time.col)))], by = floor(1/ds.factor),
       length.out =
         ceiling(ds.factor*input.table[,length(unique(get(time.col)))]))
 
  # convert to existing values for lookup
  resample.vals <- input.table[,unique(get(time.col))][resample.seq]

  return(input.table[get(time.col) %in% resample.vals,])
}
