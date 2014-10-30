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