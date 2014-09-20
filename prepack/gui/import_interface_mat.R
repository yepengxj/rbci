##### import window button actions #####

on_importmatfilechoosebutton_file_set <- function(action) {
  message("filebuttonactivated")
  previewselector <- builder$getObject("importmatfilechoosebutton")
  
  previewfile <- previewselector$GetFilename()
  # get some options also
  
  # here we need to go to the backend to process the MAT
  rbci.env$previewtext <<- rbci.preview.mat(previewfile)
}

on_importmatpreviewbutton_clicked <- function(action) {
  message("previewclicked")
  # set text if preview load succeeded
  previewbuf <- builder$getObject("datapreviewtext")
  previewbuf$text <- paste(rbci.env$previewtext,collapse="\n")
  
  # update options based on data characteristics (available cols, etc.)
  
  # add cols to listview
  
}