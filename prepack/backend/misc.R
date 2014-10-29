# define special concatenating function along fourth dimension for files
myabind <- function(x,y) {
  abind(x,y,along=4)
}