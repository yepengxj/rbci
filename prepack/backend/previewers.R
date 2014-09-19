#' Preview functions for external data files.
#' 
#' Each of these functions generates a text preview of a possible import, using 
#' 
#' @param filename A string pointing to the data file.
#' @param environment The desired enviroment to receive the data.
#' @param options A list of named options
#' @return If preview OK, outputs a preview of the import
#' @name Preview backends
NULL

#' @rdname preview.csv
rbci.preview.csv <- function(filename, 
                               environment = rbci.env, 
                               options = rbci.env$options) {
  
}

#' @rdname preview.mat
rbci.preview.mat <- function(filename, 
                             environment = rbci.env, 
                             options = rbci.env$options) {
  
  rbci.env$importedmat <- readMat(filename)
  
  # since the structure is complex, we preview with str() if no view options
  if (!options$view.head) {
    return(str(rbci.env$importedmat))
  }
  else if (options$view.head) {
    # check for other view options to properly format
    
    # build preview from options+data
  }
}