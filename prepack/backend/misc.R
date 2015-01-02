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

### pseudo-curry of gwidgets enabled() method to enable bulk enable/disable
### widgets
enabled.list <- function(state = TRUE, ...) {
    require(gWidgets)
    ### TODO throw error if state not T/F
    
    ### TODO throw error if not passed good objs
    objs <- list(...)
    
    lapply(objs, function(x) {
        enabled(x) <- state
    })
}

### hacky widget refresher, destroys and recreates widgets
refresh.widget <- function(old.widget, new.widget = old.widget) {
    delete(old.widget$container, old.widget)
    new.widget
}

scoot.gtable.row <- function(input.gtable, input.row, direction = "up") {
### Scoots rows up or down in a data.frame-like gtable or gdf
### Relies on cool frame-like coercing of gtable[] 
### TODO unique row checking/exception
### TODO error checking on table ends (fails silently currently)
    require(gWidgets)

    ## what kind of row arg did we get? a row or a row index?
    switch(class(input.row),
           "data.frame" = {
               ## if we got a row, scan to find its index
               my.ind <- rowscan.data.frame(input.gtable, input.row)
           },
           "integer" = {
               ## if we got an index, pull the row
               my.ind <- input.row
               input.row <- input.gtable[input.row,]
           })

    ## pick out the swapping buddy
    switch(direction,
           "up" = {
               row.ind <- my.ind-1
               swap.row <- input.gtable[row.ind,]
           },
           "down" = {
               row.ind <- my.ind+1
               swap.row <- input.gtable[row.ind,]
           })
    
    ## make the swap
    input.gtable[row.ind,] <- input.row
    input.gtable[my.ind,] <- swap.row
    
    ## no returns should be necessary, since changes are by ref
### TODO use later for error handling
    return()
}

rowscan.data.frame <- function(df,row) {
### finds the row index(es) of a given row in a given dataframe
### from https://stat.ethz.ch/pipermail/r-help/2010-November/261170.html
    
    ## first candidate: fails on type issues
    ## rows <- which(apply(mapply(df, row, FUN="=="), MARGIN=1, FUN=all))
    
    ## string search: works, might be slow
### TODO revisit this
    which((apply(df, 1, toString) %in% toString(row)))
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
                             value.var = val.col))
    }
}
