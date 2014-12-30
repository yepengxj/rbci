### define special concatenating function along fourth dimension for files
myabind <- function(x,y) {
  abind(x,y,along=4)
}

### curried abind for foreach; binds its arguments along 3rd dimension
abind3curry <- function(...) {
    abind(...,along=3)
}

### readRDS()/unserialize() doesn't work right now, so use RData and envs
## http://stackoverflow.com/a/5577647/2023432
load_obj <- function(f)
{
  env <- new.env()
  nm <- load(f, env)[1]
  env[[nm]]
}

### quick correlation matrix function for data.tables using special dcast()
acorr.table <- function(input.table, time.col, chan.col, val.col, trial.col) {
    require(data.table)
    require(foreach)
    
    ## in case we haven't been given something properly keyed
    setkeyv(input.table, trial.col, chan.col, sample.col)
    corr.dt <- foreach(seq_len(max(get(trial.col))),
                         .inorder = FALSE,
                         .combine = abind3curry,
                         .multicombine = TRUE) %dopar% {
        
        cor(dcast.data.table(input.table[J(get(trial.col))],
                             as.formula(paste(time.col,"~",chan.col)),
                             value.var = val.col)
    }
}
