# define special concatenating function along fourth dimension for files
myabind <- function(x,y) {
  abind(x,y,along=4)
}

# readRDS()/unserialize() doesn't work right now, so use RData and envs
# http://stackoverflow.com/a/5577647/2023432
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
### TODO unique row checking/exception
    my.row <- rowscan.data.frame(input.gtable, input.row)
}

rowscan.data.frame <- function(df,row) {
### finds the row index(es) of a given row in a given dataframe
### from https://stat.ethz.ch/pipermail/r-help/2010-November/261170.html

    rows <- which(apply(mapply(df, row, FUN="=="), MARGIN=1, FUN=all));

}
