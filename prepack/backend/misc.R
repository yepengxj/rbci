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
