source("./backend/previewers.R")

##### import window button actions #####

on_importcsvpreviewbutton_clicked <- function(action) {
  previewselector <- builder$getObject("importcsvfilechoosebutton")
  
  previewfile <- previewselector$GetUri()
  # get some options also
  
  # here we need to go to the backend to process the CSV
  previewtext <- import.csv.preview(previewfile)
  
  # set text if preview load succeeded
  previewbuf <- builder$getObject("datapreviewtext")
  previewbuf$text <- previewtext
  
}

on_importmatfilechoosebutton_file_activated <- function(action) {
  previewselector <- builder$getObject("importmatfilechoosebutton")
  
  previewfile <- previewselector$GetFilename()
  # get some options also
  
  # here we need to go to the backend to process the MAT
  previewtext <- rbci.preview.mat(previewfile)
  
  # set text if preview load succeeded
  previewbuf <- builder$getObject("datapreviewtext")
  previewbuf$text <- paste(previewtext,collapse="\n")
  
  # update options based on data characteristics (available cols, etc.)
}

